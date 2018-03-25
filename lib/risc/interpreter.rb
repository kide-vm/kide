
require_relative "eventable"

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
    include Eventable
    include Logging
    log_level :info

    attr_reader :instruction     # current instruction or pc
    attr_reader :clock    # current instruction or pc

    attr_reader :registers     # the registers, 16 (a hash, sym -> contents)
    attr_reader :stdout     # collect the output
    attr_reader :state # running etc
    attr_reader :flags  # somewhat like the lags on a cpu, hash  sym => bool (zero .. . )

    #start in state :stopped and set registers to unknown
    def initialize()
      @state = :stopped
      @stdout = ""
      @registers = {}
      @flags = {  :zero => false , :plus => false ,
                  :minus => false , :overflow => false }
      @clock = 0
      (0...12).each do |r|
        set_register "r#{r}".to_sym , "r#{r}:unknown"
      end
    end

    def start( instruction )
      initialize
      set_state(:running)
      set_instruction( instruction )
    end

    def set_state( state )
      old = @state
      return if state == old
      @state = state
      trigger(:state_changed , old , state )
    end

    def set_instruction( i )
      raise "set to same instruction #{i}:#{i.class}" if @instruction == i
      old = @instruction
      @instruction = i
      trigger(:instruction_changed, old , i)
      set_state( :exited) unless i
    end

    def get_register( reg )
      reg = reg.symbol if reg.is_a? Risc::RiscValue
      raise "Not a register #{reg}" unless Risc::RiscValue.look_like_reg(reg)
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
      reg = reg.symbol if reg.is_a? Risc::RiscValue
      @registers[reg] = val
      trigger(:register_changed, reg ,  old , val)
    end

    def tick
      return unless @instruction
      @clock += 1
      name = @instruction.class.name.split("::").last
      log.debug "#{@clock.to_s}: #{@instruction.to_s}"
      fetch = send "execute_#{name}"
      log.debug register_dump
      return unless fetch
      set_instruction @instruction.next
    end

    # Label is a noop.
    def execute_Label
      true
    end
    # Instruction interpretation starts here
    def execute_Branch
      label = @instruction.label
      set_instruction label
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
      value = value.value if value.is_a?(Mom::Constant)
      set_register( to , value )
      true
    end

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
      #value = value.object_id unless value.is_a? Fixnum
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
      set_instruction @instruction.method.risc_instructions
      false
    end

    def execute_FunctionReturn
      link = get_register( @instruction.register )
      log.debug "Return to #{link}"
      @instruction = link
      # we jump back to the call instruction. so it is as if the call never happened and we continue
      true
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

    def handle_operator(left, right)
      left = left.object_id unless left.is_a?(Integer)
      right = right.object_id unless right.is_a?(Integer)
      case @instruction.operator
      when :+
        return left + right
      when :-
        return left - right
      when :>>
        return left / (2**right)
      when :<<
        return left * (2**right)
      when :*
        return left * right
      when :&
        return left & right
      when :|
        return left | right
      else
        raise "unimplemented  '#{@instruction.operator}' #{@instruction}"
      end
    end

    def register_dump
      (0..7).collect do |reg|
        value = @registers["r#{reg}".to_sym]
        str = "#{reg}-" +
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
