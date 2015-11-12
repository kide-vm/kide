
require_relative "eventable"

module Interpreter
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

    def initialize
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

    def start instruction
      initialize
      set_state(:running)
      set_instruction instruction
    end

    def set_state state
      old = @state
      return if state == old
      @state = state
      trigger(:state_changed , old , state )
    end

    def set_instruction i
      return if @instruction == i
      old = @instruction
      @instruction = i
      trigger(:instruction_changed, old , i)
      set_state( :exited) unless i
    end

    def get_register( reg )
      reg = reg.symbol if reg.is_a? Register::RegisterValue
      raise "Not a register #{reg}" unless Register::RegisterValue.look_like_reg(reg)
      @registers[reg]
    end

    def set_register reg , val
      old = get_register( reg ) # also ensures format
      if val.is_a? Fixnum
        @flags[:zero] = (val == 0)
        @flags[:plus] = (val > 0)
        @flags[:minus] = (val < 0)
        log.debug "Set_flags #{val}  :#{@flags.inspect}"
      else
        @flags[:zero] =  @flags[:plus] = true
        @flags[:minus] = false
      end
      return if old === val
      reg = reg.symbol if reg.is_a? Register::RegisterValue
      @registers[reg] = val
      trigger(:register_changed, reg ,  old , val)
    end

    def tick
      return unless @instruction
      @clock += 1
      name = @instruction.class.name.split("::").last
      log.debug "#{@clock.to_s}: #{@instruction.to_s}"
      fetch = send "execute_#{name}"
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
    def execute_IsNotzero
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
      #value = value.object_id unless value.is_a?(Fixnum)
      set_register( to , value )
      true
    end

    def execute_GetSlot
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      value = object.get_internal( index )
      #value = value.object_id unless value.is_a? Fixnum
      set_register( @instruction.register , value )
      true
    end

    def execute_SetSlot
      value = get_register( @instruction.register )
      object = get_register( @instruction.array )
      if( @instruction.index.is_a?(Numeric) )
        index = @instruction.index
      else
        index = get_register(@instruction.index)
      end
      object.set_internal( index , value )
      trigger(:object_changed, @instruction.array , index)
      true
    end

    def execute_RegisterTransfer
      value = get_register @instruction.from
      set_register @instruction.to , value
      true
    end

    def execute_FunctionCall
      set_instruction @instruction.method.instructions
      false
    end

    def execute_FunctionReturn
      object = get_register( @instruction.register )
      link = object.get_internal( @instruction.index )
      @instruction = link
      # we jump back to the call instruction. so it is as if the call never happened and we continue
      true
    end

    def execute_Syscall
      name = @instruction.name
      ret_value = 0
      case name
      when :putstring
        str = get_register( :r1 ) # should test length, ie r2
        case str
        when Symbol
          @stdout += str.to_s
          ret_value = str.to_s.length
        when Parfait::Word
          @stdout += str.to_string
          ret_value = str.char_length
        else
          raise "NO string for putstring #{str.class}:#{str.object_id}" unless str.is_a?(Symbol)
        end
      when :exit
        set_instruction(nil)
        return false
      else
        raise "un-implemented syscall #{name}"
      end
      set_register( :r0 , ret_value ) # syscalls return into r0 , usually some int
      true
    end

    def execute_OperatorInstruction
      left = get_register(@instruction.left) || 0
      rr = @instruction.right
      right = get_register(rr) || 0
      @flags[:overflow] = false
      case @instruction.operator.to_s
      when "+"
        result = left + right
      when "-"
        result = left - right
      when ">>"
        result = left >> right
      when "<<"
        result = left << right
      when "*"
        result = left * right
      when "&"
        result = left & right
      when "|"
        result = left | right
      when "=="
        result = (left == right) ? 1 : 0
      else
        raise "unimplemented  '#{@instruction.operator}' #{@instruction}"
      end
      if( result.is_a? Bignum)
        @flags[:overflow] = true
        result = result % 2**62
      else
        result = result.to_i
      end
      log.debug "#{@instruction} == #{result}(#{result.class})   (#{left}|#{right})"
      right = set_register(@instruction.left , result)
      true
    end
  end
end
