module Risc

  # An interpreter for the register level. As the register machine is a simple model,
  # interpreting it is not so terribly difficult.
  #
  # There is a certain amount of basic machinery to fetch and execute the next instruction
  # (as a cpu would), and then there is a method for each instruction. Eg an instruction SlotToReg
  # will be executed by method execute_SlotToReg
  #
  # The Interpreter (a bit like a cpu) has a state flag, a current instruction and registers
  # We collect the stdout (as a hack not to interpret the OS)
  #
  class Interpreter
    # fire events for changed pc and register contents
    include Util::Eventable
    include Util::Logging
    log_level :info

    attr_reader :instruction , :clock , :pc  # current instruction and pc
    attr_reader :registers     # the registers, 16 (a hash, sym -> contents)
    attr_reader :stdout,  :state , :flags  # somewhat like the lags on a cpu, hash  sym => bool (zero .. . )

    #start in state :stopped and set registers to unknown
    def initialize( linker )
      @stdout , @clock , @pc , @state = "", 0 , 0 , :stopped
      @registers = {}
      @flags = {  :zero => false , :plus => false ,
                  :minus => false , :overflow => false }
      (0...12).each do |reg|
        set_register "r#{reg}".to_sym , "r#{reg}:unknown"
      end
      @linker = linker
    end

    def start_program
      initialize
      init = @linker.cpu_init
      set_state(:running)
      set_pc( Position.get(init).at )
    end

    def set_state( state )
      old = @state
      return if state == old
      @state = state
      trigger(:state_changed , old , state )
    end

    def set_pc( pos )
      raise "Not int #{pos}" unless pos.is_a? Numeric
      position = Position.at(pos)
      raise "No position at 0x#{pos.to_s(16)}" unless position
      if position.is_a?(CodeListener)
        raise "Setting Code #{clock}-#{position}, #{position.method}"
        #return set_pc(position.at + Parfait::BinaryCode.byte_offset)
      end
      log.debug "Setting Position #{clock}-#{position}, "
      #raise "not instruction position #{position}-#{position.class}-#{position.object.class}" unless position.is_a?(InstructionPosition)
      set_instruction( position.object )
      @clock += 1
      @pc = position.at
    end

    def set_instruction( instruction )
      raise "set to same instruction #{instruction}:#{instruction.class}" if @instruction == instruction
      log.debug "Setting Instruction #{instruction.class}"
      old = @instruction
      @instruction = instruction
      trigger(:instruction_changed, old , instruction)
      set_state( :exited ) unless instruction
    end

    def get_register( reg )
      reg = reg.symbol if reg.is_a? Risc::RegisterValue
      raise "Not a register #{reg}" unless Risc::RegisterValue.look_like_reg(reg)
      @registers[reg]
    end

    def set_register( reg , val )
      old = get_register( reg ) # also ensures format
      if val.is_a? Fixnum
        @flags[:zero] = (val == 0)
        @flags[:plus] = (val >= 0)
        @flags[:minus] = (val < 0)
        log.debug "Set_flags #{val}  :#{@flags.inspect}"
      else
        @flags[:zero] =  @flags[:plus] = true
        @flags[:minus] = false
      end
      return if old === val
      reg = reg.symbol if reg.is_a? Risc::RegisterValue
      val = Parfait.object_space.nil_object if val.nil? #because that's what real code has
      @registers[reg] = val
      trigger(:register_changed, reg ,  old , val)
    end

    def tick
      unless @instruction
        log.debug "No Instruction , No Tick"
        return @clock
      end
      name = @instruction.class.name.split("::").last
      log.debug "#{@pc.to_s(16)}:#{@clock}: #{@instruction.to_s}"
      fetch = send "execute_#{name}"
      log.debug register_dump
      if fetch
        pc = @pc + @instruction.byte_length
        set_pc(pc)
      else
        log.debug "No Fetch"
      end
      @clock
    end

    # Instruction interpretation starts here
    def execute_DynamicJump
      method =  get_register(@instruction.register)
      set_pc( Position.get(method.cpu_instructions).at )
      false
    end
    def execute_Branch
      label = @instruction.label
      pos = Position.get(label).at
      pos += Parfait::BinaryCode.byte_offset if label.is_a?(Parfait::BinaryCode)
      set_pc pos
      false
    end

    def execute_IsZero
       @flags[:zero] ?  execute_Branch : true
    end
    def execute_IsNotZero
       @flags[:zero] ? true : execute_Branch
    end
    def execute_IsPlus
       @flags[:plus] ?  execute_Branch : true
    end
    def execute_IsMinus
       @flags[:minus] ?  execute_Branch : true
    end

    def execute_LoadConstant
      to = @instruction.register
      value = @instruction.constant
      value = value.address if value.is_a?(Label)
      set_register( to , value )
      true
    end
    alias :execute_LoadData :execute_LoadConstant

    def execute_SlotToReg
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      case object
      when Symbol
        raise "Must convert symbol to word:#{object}" unless( index == 2 )
        value = object.to_s.length
      when nil
        raise "error #{@instruction} retrieves nil"
      else
        value = object.get_internal_word( index )
      end
      log.debug "#{@instruction} == #{object}(#{object.class})   (#{value}|#{index})"
      set_register( @instruction.register , value )
      true
    end

    def execute_RegToSlot
      value = get_register( @instruction.register )
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      object.set_internal_word( index , value )
      trigger(:object_changed, @instruction.array , index)
      true
    end

    def execute_ByteToReg
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      raise "Unsupported action, must convert symbol to word:#{object}" if object.is_a?(Symbol)
      value = object.get_char( index )
      #value = value.object_id unless value.is_a? Fixnum
      set_register( @instruction.register , value )
      true
    end

    def execute_RegToByte
      value = get_register( @instruction.register )
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      object.set_char( index , value )
      trigger(:object_changed, @instruction.array , index / 4 )
      true
    end

    def execute_Transfer
      value = get_register @instruction.from
      set_register @instruction.to , value
      true
    end

    def execute_FunctionCall
      meth = @instruction.method
      at = Position.get(meth.binary).at
      log.debug "Call to #{meth.name} at:#{at}"
      set_pc(at + Parfait::BinaryCode.byte_offset)
      #set_instruction @instruction.method.risc_instructions
      false
    end

    def execute_FunctionReturn
      link = get_register( @instruction.register )
      log.debug "Return to #{link} #{link.class}"
      set_pc link
      false
    end

    def execute_Syscall
      name = @instruction.name
      ret_value = 0
      case name
      when :putstring
        ret_value = handle_putstring
      when :exit
        set_instruction(nil)
        return false
      else
        raise "un-implemented syscall #{name}"
      end
      set_register( :r0 , ret_value ) # syscalls return into r0 , usually some int
      true
    end

    def handle_putstring
      str = get_register( :r1 ) # should test length, ie r2
      case str
      when Symbol
        @stdout += str.to_s
        return str.to_s.length
      when Parfait::Word
        @stdout += str.to_string
        return str.char_length
      else
        raise "NO string for putstring #{str.class}:#{str.object_id}" unless str.is_a?(Symbol)
      end
    end

    def execute_OperatorInstruction
      left = get_register(@instruction.left) || 0
      rr = @instruction.right
      right = get_register(rr) || 0
      @flags[:overflow] = false
      result = handle_operator(left,right)
      if( result > 2**32 )
        @flags[:overflow] = true
        result = result % 2**32
      else
        result = result.to_i
      end
      log.debug "#{@instruction} == #{result}(#{result.class})   (#{left}|#{right})"
      right = set_register(@instruction.left , result)
      true
    end

    def make_op_arg(arg)
      case arg
      when Integer
          arg
      when Parfait::Word
        arg.to_string.to_sym.object_id
      when String
        arg.to_sym.object_id
      when Symbol
        arg.object_id
      when Parfait::Object
        arg.object_id
      else
        raise "Op arg #{arg}:#{arg.class}"
      end
    end

    def handle_operator(left, right)
      left = make_op_arg(left)
      right = make_op_arg(right)
      case @instruction.operator
      when :+
        left + right
      when :-
        if( left.is_a?(String) or right.is_a?(String))
          left == right ? 0 : 1       #for opal, and exception
        else
          left - right
        end
      when :>>
        left / (2**right)
      when :<<
        left * (2**right)
      when :*
        left * right
      when :&
        left & right
      when :|
        left | right
      else
        raise "unimplemented  '#{@instruction.operator}' #{@instruction}"
      end
    end

    def register_dump
      (0..7).collect do |reg|
        value = @registers["r#{reg}".to_sym]
        "#{reg}-" +
        case value
        when String
          value[0..10]
        else
          value.class.name.split("::").last
        end
      end.join("|")
    end
  end
end
