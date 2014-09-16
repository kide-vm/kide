require_relative "nodes"

module Arm
  # There are only three call instructions in arm branch (b), call (bl) and syscall (swi)
  
  # A branch could be called a jump as it has no notion of returning
  
  # The pc is put into the link register to make a return possible
  # a return is affected by moving the stored link register into the pc, effectively a branch
  
  # swi (SoftWareInterrupt) or system call is how we call the kernel.
  # in Arm the register layout is different and so we have to place the syscall code into register 7
  # Registers 0-6 hold the call values as for a normal c call
  
  class CallInstruction < ::Register::CallInstruction
    include Arm::Constants

    def initialize(first, attributes)
      super(first , attributes)
      @attributes[:update_status] = 0
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
    end
    
    def assemble(io)
      case @attributes[:opcode]
      when :b, :call
        arg = @first
        #puts "BLAB #{arg.inspect}"
        if( arg.is_a? Fixnum ) #HACK to not have to change the code just now
          arg = Virtual::IntegerConstant.new( arg )
        end
        if arg.is_a?(Virtual::Block) or arg.is_a?(Virtual::CompiledMethod)
          #relative addressing for jumps/calls
          diff = arg.position - self.position
          # but because of the arm "theoretical" 3- stage pipeline, we have to subtract 2 words (fetch/decode)
          # But, for methods, this happens to be the size of the object header, so there it balances out, but not blocks
          diff -=  8 if arg.is_a?(Virtual::Block)
          arg = Virtual::IntegerConstant.new(diff)
        end
        if (arg.is_a?(Virtual::IntegerConstant))
          jmp_val = arg.integer >> 2
          packed = [jmp_val].pack('l')
          # signed 32-bit, condense to 24-bit
          # TODO add check that the value fits into 24 bits
          io << packed[0,3]
        else
          raise "else not coded arg =#{arg}: #{inspect}"
        end
        io.write_uint8 op_bit_code | (COND_CODES[@attributes[:condition_code]] << 4)
      when :swi
        arg = @first
        if( arg.is_a? Fixnum ) #HACK to not have to change the code just now
          arg = Virtual::IntegerConstant.new( arg )
        end
        if (arg.is_a?(Virtual::IntegerConstant))
          packed = [arg.integer].pack('L')[0,3]
          io << packed
          io.write_uint8 0b1111 | (COND_CODES[@attributes[:condition_code]] << 4)
        else
          raise "invalid operand argument expected literal not #{arg} #{inspect}"
        end
      else
        raise "Should not be the case #{inspect}"
      end
    end
    
  end#class
end