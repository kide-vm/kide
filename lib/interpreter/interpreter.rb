
require_relative "eventable"

module Interpreter
  class Interpreter
    # fire events for changed pc and register contents
    include Eventable

    attr_reader :instruction     # current instruction or pc
    attr_reader :clock    # current instruction or pc
    # an (arm style) link register. store the return address to return to
    attr_reader :link
    # current executing block. since this is not a hardware simulator this is luxury
    attr_reader :block
    attr_reader :registers     # the registers, 16 (a hash, sym -> contents)
    attr_reader :stdout     # collect the output
    attr_reader :state # running etc
    attr_reader :flags  # somewhat like the lags on a cpu, hash  sym => bool (zero .. . )

    def initialize
      @state = "runnnig"
      @stdout = ""
      @registers = {}
      @flags = {  :zero => false , :positive => false ,
                  :negative=> false , :overflow => false }
      @clock = 0
      (0...12).each do |r|
        set_register "r#{r}".to_sym , "r#{r}:unknown"
      end
    end

    def start bl
      set_block  bl
    end

    def set_block bl
      return if @block == bl
      raise "Error, nil block" unless bl
      old = @block
      @block = bl
      trigger(:block_changed , old , bl)
      set_instruction bl.codes.first
    end

    def set_instruction i
      @state = "exited" unless i
      return if @instruction == i
      old = @instruction
      @instruction = i
      trigger(:instruction_changed, old , i)
    end

    def get_register( reg )
      reg = reg.symbol if reg.is_a? Register::RegisterValue
      raise "Not a register #{reg}" unless Register::RegisterValue.look_like_reg(reg)
      @registers[reg]
    end

    def set_register reg , val
      old = get_register( reg ) # also ensures format
      unless val.is_a? String
        @flags[:zero] = (val == 0)
        @flags[:positive] = (val > 0)
        @flags[:negative] = (val < 0)
        #puts "Set_flags #{val}  :zero=#{@flags[:zero]}"

      end
      return if old === val
      reg = reg.symbol if reg.is_a? Register::RegisterValue
      @registers[reg] = val
      trigger(:register_changed, reg ,  old , val)
    end

    def tick
      return unless @instruction
      @clock += 1
      #puts @instruction
      name = @instruction.class.name.split("::").last
      fetch = send "execute_#{name}"
      return unless fetch
      fetch_next_intruction
    end

    def fetch_next_intruction
      if(@instruction != @block.codes.last)
        set_instruction @block.codes[  @block.codes.index(@instruction)  + 1]
      else
        next_b = @block.method.source.blocks.index(@block) + 1
        set_block @block.method.source.blocks[next_b]
      end
    end

    def object_for reg
      id = get_register(reg)
      Virtual.machine.objects[id]
    end

    # Instruction interpretation starts here
    def execute_Branch
      target = @instruction.block
      set_block target
      false
    end

    def execute_IsZero
      #puts @instruction.inspect
      if( @flags[:zero] )
        target = @instruction.block
        set_block target
        return false
      else
        return true
      end
    end

    def execute_LoadConstant
      to = @instruction.register
      value = @instruction.constant
      value = value.object_id unless value.is_a?(Fixnum)
      set_register( to , value )
      true
    end

    def execute_GetSlot
      object = object_for( @instruction.array )
      value = object.internal_object_get( @instruction.index )
      value = value.object_id unless value.is_a? Fixnum
      set_register( @instruction.register , value )
      true
    end

    def execute_SetSlot
      value = object_for( @instruction.register )
      object = object_for( @instruction.array )
      object.internal_object_set( @instruction.index , value )
      trigger(:object_changed, @instruction.array , @instruction.index)
      true
    end

    def execute_RegisterTransfer
      value = get_register @instruction.from
      set_register @instruction.to , value
      true
    end

    def execute_FunctionCall
      @link = [@block , @instruction]
      #puts "Call link #{@link}"
      next_block = @instruction.method.source.blocks.first
      set_block next_block
      false
    end

    def execute_SaveReturn
      object = object_for @instruction.register
      raise "save return has nothing to save" unless @link
      #puts "Save Return link #{@link}"
      object.internal_object_set @instruction.index , @link
      trigger(:object_changed, @instruction.register , @instruction.index )
      @link = nil
      true
    end

    def execute_FunctionReturn
      object = object_for( @instruction.register )
      link = object.internal_object_get( @instruction.index )
      #puts "FunctionReturn link #{@link}"
      @block , @instruction = link
      # we jump back to the call instruction. so it is as if the call never happened and we continue
      true
    end

    def execute_Syscall
      name = @instruction.name
      ret_value = 0
      case name
      when :putstring
        str = object_for( :r1 ) # should test length, ie r2
        raise "NO string for putstring #{str.class}:#{str.object_id}" unless str.is_a? Symbol
        @stdout += str.to_s
        ret_value = str.to_s.length
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
      left = get_register(@instruction.left)
      rr = @instruction.right
      right = get_register(rr)
      case @instruction.operator.to_s
      when "+"
        result = left + right
      when "-"
        result = left - right
      when "/"
        result = left / right
      when "*"
        #TODO set overflow, reduce result to int
        result = left * right
      when "=="
        result = (left == right) ? 1 : 0
      else
        raise "unimplemented  '#{@instruction.operator}' #{@instruction}"
      end
      #puts "#{@instruction} == #{result}   (#{left}|#{right})"
      right = set_register(@instruction.left , result)
      true
    end
  end
end
