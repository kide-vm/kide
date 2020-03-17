module Risc

  # An interpreter for the register level. As the register machine is a simple model,
  # interpreting it is not so terribly difficult.
  #
  # There is a certain amount of basic machinery to fetch and execute the next instruction
  # (as a cpu would), and then there is a method for each instruction. Eg an instruction SlotToReg
  # will be executed by method execute_SlotToReg
  #
  # The Interpreter (a bit like a cpu) has a state flag, a current instruction and registers
  # We collect the stdout (as a hack not to interpret the OS) in a string. It can also be passed
  # in to the init, as an IO
  #
  class Interpreter
    # fire events for changed pc and register contents
    include Util::Eventable
    include Util::Logging
    log_level :info

    attr_reader :instruction , :clock , :pc  # current instruction and pc
    attr_reader :registers     # the registers, 16 (a hash, sym -> contents)
    attr_reader :stdout,  :state , :flags  # somewhat like the flags on a cpu, hash  sym => bool (zero .. . )

    # start in state :stopped and set registers to unknown
    # Linker gives the state of the program
    # Passing a stdout in (an IO, only << called) can be used to get output immediately.
    def initialize( linker , stdout = "")
      @stdout , @clock , @pc , @state = stdout, 0 , 0 , :stopped
      @registers = {}
      reset_flags
      (0...InterpreterPlatform.new.num_registers).each do |reg|
        #set_register "r#{reg}".to_sym , "r#{reg}:unknown"
      end
      @linker = linker
    end

    def start_program()
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

    # set all flags to false
    def reset_flags
      @flags = {  :zero => false , :plus => false ,
                  :minus => false , :overflow => false }
    end

    def set_pc( pos )
      raise "Not int #{pos}" unless pos.is_a? Numeric
      position = Position.at(pos)
      raise "No position at 0x#{pos.to_s(16)}" unless position
      log.debug ""
      log.debug "Setting Position #{clock}-#{position}, "
      set_instruction( position.object )
      @clock += 1
      @pc = position.at
    end

    def set_instruction( instruction )
      raise "set to same instruction #{instruction}:#{instruction.class} at #{clock}" if @instruction == instruction
      #log.debug "Setting Instruction #{instruction.class}"
      old = @instruction
      @instruction = instruction
      trigger(:instruction_changed, old , instruction)
      set_state( :exited ) unless instruction
    end

    def get_register( reg )
      reg = reg.symbol if reg.is_a? Risc::RegisterValue
      #raise "Not a register #{reg}" unless Risc::RegisterValue.look_like_reg(reg)
      @registers[reg]
    end

    def set_register( reg , val )
      reg = reg.symbol if reg.is_a? Risc::RegisterValue
      log.debug "setting #{reg} == #{val}"
      old = get_register( reg )
      if val.is_a? ::Integer
        @flags[:zero] = (val == 0)
        @flags[:plus] = (val >= 0)
        @flags[:minus] = (val < 0)
        log.debug "Set_flags #{val}  :#{@flags.inspect}"
      else
        @flags[:zero] =  @flags[:plus] = true
        @flags[:minus] = false
      end
      return if old === val
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
      register_dump
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
      log.debug "Register at: #{@instruction.register} , has #{method.class}"
      pos = Position.get(method.binary)
      log.debug "Jump to binary at: #{pos} #{method.name}:#{method.binary.class}"
      raise "Invalid position for #{method.name}" unless pos.valid?
      pos = pos + Parfait::BinaryCode.byte_offset
      set_pc( pos )
      false
    end
    def execute_Branch
      label = @instruction.label
      log.debug "Branch to Label: #{@instruction.label}"
      pos = Position.get(label).at
      pos += Parfait::BinaryCode.byte_offset if label.is_a?(Parfait::BinaryCode)
      set_pc( pos )
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
        if(index == 0)
          value = object.get_type
        elsif(index==1)
          value = object.to_s.length
        else
          raise "Must convert symbol to word:#{object}:#{index}"
        end
      when nil
        raise "error #{@instruction} retrieves nil"
      else
        value = object.get_internal_word( index )
        #log.debug "Getting #{index} from #{object} value=#{value}"
        #log.debug "type=#{object.type} get_type=#{object.get_type} intern=#{object.get_internal_word(0)}"
      end
      log.debug "#{@instruction} == #{object}(#{Position.get(object)})   (#{value}|#{index})"
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
      log.debug "RegToSlot #{object}[#{index}] == #{value}"
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
      #value = value.object_id unless value.is_a? ::Integer
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
      at = Position.get(meth.binary)
      log.debug "Call to #{meth.name} at:#{at}"
      set_pc(at + Parfait::BinaryCode.byte_offset)
      false
    end

    def execute_FunctionReturn
      link = get_register( @instruction.register )
      log.debug "Return to #{link.to_s(16)}"
      set_pc link.value
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
      when :died
        raise "Method #{@registers[:r1]} not found for #{@registers[:r0].receiver}"
      else
        raise "un-implemented syscall #{name}"
      end
      set_register( :syscall_1 , ret_value ) # syscalls return into syscall_1
      true
    end

    def handle_putstring
      str = get_register( :"syscall_1" ) # should test length, ie r2
      case str
      when Symbol
        @stdout << str.to_s
        @stdout.flush if @stdout.respond_to?(:flush)
        return str.to_s.length
      when Parfait::Word
        @stdout << str.to_string
        @stdout.flush if @stdout.respond_to?(:flush)
        return str.char_length
      else
        raise "NO string for putstring #{str.class}:#{str.object_id}" unless str.is_a?(Symbol)
      end
    end

    def execute_OperatorInstruction
      reset_flags
      left = get_register(@instruction.left) || 0
      rr = @instruction.right
      right = get_register(rr) || 0
      result = handle_operator(left,right)
      if( result > 2**32 )
        @flags[:overflow] = true
        result = result % 2**32
      else
        result = result.to_i
      end
      log.debug "#{@instruction} == #{result}(#{result.class})   (#{left}|#{right})"
      set_register(@instruction.result , result)
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
      @registers.keys.sort.each do |reg|
        value = @registers[reg]
        log.debug "#{reg}:#{value.to_s[0..50]}"
      end
    end

    def old_register_dump
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
