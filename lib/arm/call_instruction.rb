require_relative "nodes"

module Arm
  # There are only three call instructions in arm branch (b), call (bl) and syscall (swi)
  
  # A branch could be called a jump as it has no notion of returning
  
  # A call has the bl code as someone thought "branch with link" is a useful name.
  # The pc is put into the link register to make a return possible
  # a return is affected by moving the stored link register into the pc, effectively a branch
  
  # swi (SoftWareInterrupt) or system call is how we call the kernel.
  # in Arm the register layout is different and so we have to place the syscall code into register 7
  # Registers 0-6 hold the call values as for a normal c call
  
  class CallInstruction < Vm::CallInstruction
    include Arm::Constants
    
    # arm intrucioons are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end

    def initialize(attributes)
      super(attributes)
      @attributes[:update_status_flag] = 0
      @attributes[:condition_code] = :al
    end
    
    def assemble(io)
      case @attributes[:opcode]
      when :b, :bl
        arg = @attributes[:left]
        #puts "BLAB #{arg.inspect}"
        if( arg.is_a? Fixnum ) #HACK to not have to change the code just now
          arg = Arm::NumLiteral.new( arg )
        end
        if arg.is_a? Vm::Code
          diff = arg.position - self.position - 8
          arg = Arm::NumLiteral.new(diff)
        end
        if (arg.is_a?(Arm::NumLiteral))
          jmp_val = arg.value >> 2
          packed = [jmp_val].pack('l')
          # signed 32-bit, condense to 24-bit
          # TODO add check that the value fits into 24 bits
          io << packed[0,3]
        else
          raise "else not coded #{inspect}"
        end
        io.write_uint8 OPCODES[opcode] | (COND_CODES[@attributes[:condition_code]] << 4)
      when :swi
        arg = @attributes[:left]
        if( arg.is_a? Fixnum ) #HACK to not have to change the code just now
          arg = Arm::NumLiteral.new( arg )
        end
        if (arg.is_a?(Arm::NumLiteral))
          packed = [arg.value].pack('L')[0,3]
          io << packed
          io.write_uint8 0b1111 | (COND_CODES[@attributes[:condition_code]] << 4)
        else
          raise "invalid operand argument expected literal not #{arg} #{inspect}"
        end
      end
    end
    
  end#class
end