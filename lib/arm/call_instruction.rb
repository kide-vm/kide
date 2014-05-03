require_relative "instruction"

module Asm
  # There are only three call instructions in arm branch (b), call (bl) and syscall (swi)
  
  # A branch could be called a jump as it has no notion of returning
  
  # A call has the bl code as someone thought "branch with link" is a useful name.
  # The pc is put into the link register to make a return possible
  # a return is affected by moving the stored link register into the pc, effectively a branch
  
  # swi (SoftWareInterrupt) or system call is how we call the kernel.
  # in Arm the register layout is different and so we have to place the syscall code into register 7
  # Registers 0-6 hold the call values as for a normal c call
  
  class CallInstruction < Instruction
    
    def assemble(io)
      case opcode
      when :b, :bl
        arg = args[0]
        if arg.is_a? Block
          diff = arg.position - self.position - 8
          arg = NumLiteral.new(diff)
        end
        if (arg.is_a?(Asm::NumLiteral))
          jmp_val = arg.value >> 2
          packed = [jmp_val].pack('l')
          # signed 32-bit, condense to 24-bit
          # TODO add check that the value fits into 24 bits
          io << packed[0,3]
        else
          raise "else not coded #{arg.inspect}"
        end
        io.write_uint8 OPCODES[opcode] | (COND_CODES[@condition_code] << 4)
      when :swi
        arg = args[0]
        if (arg.is_a?(Asm::NumLiteral))
          packed = [arg.value].pack('L')[0,3]
          io << packed
          io.write_uint8 0b1111 | (COND_CODES[@condition_code] << 4)
        else
          raise Asm::AssemblyError.new("invalid operand argument expected literal not #{arg}")
        end
      end
    end
    
  end#class
end