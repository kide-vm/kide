module Asm
  # ADDRESSING MODE 4 ,  Calling
  
  class CallInstruction < Instruction
    include Asm::InstructionTools

    def initialize(opcode , args)
      super(opcode,args)
    end
    
    def assemble(io, as)
      s = @update_status_flag? 1 : 0
      case opcode
      when :b, :bl
        arg = args[0]
        if arg.is_a? Label
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
        io.write_uint8 OPCODES[opcode] | (COND_CODES[@cond] << 4)
      when :swi
        arg = args[0]
        if (arg.is_a?(Asm::NumLiteral))
          packed = [arg.value].pack('L')[0,3]
          io << packed
          io.write_uint8 0b1111 | (COND_CODES[@cond] << 4)
        else
          raise Asm::AssemblyError.new("invalid operand argument expected literal not #{arg}")
        end
      end
    end
    
  end#class
end