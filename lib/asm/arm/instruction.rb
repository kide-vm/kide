require "asm/assembly_error"
require "asm/arm/instruction_tools"
require "asm/arm/normal_builder"
require "asm/arm/memory_access_builder"
require "asm/arm/stack_builder"

module Asm
  module Arm

    class Instruction
      include InstructionTools

      COND_POSTFIXES = Regexp.union(%w(eq ne cs cc mi pl vs vc hi ls ge lt gt le al)).source
      def initialize(node)
        @node = node
        opcode = node.opcode
        args = node.args

        opcode = opcode.downcase
        @cond = :al
        if (opcode =~ /(#{COND_POSTFIXES})$/)
          @cond = $1.to_sym
          opcode = opcode[0..-3]
        end unless opcode == 'teq'
        if (opcode =~ /s$/)
          @s = true
          opcode = opcode[0..-2]
        else
          @s = false
        end
        @opcode = opcode.downcase.to_sym
        @args = args
      end
      attr_reader :opcode, :args , :position

      def affect_status
        @s
      end

      def at position 
        @position = position
      end
      
      def length
        4
      end
      
      RelocHandler = nil # Asm::Arm.method(:write_resolved_relocation)

      def assemble(io, as)
        s = @s ? 1 : 0
        case opcode
        when :adc, :add, :and, :bic, :eor, :orr, :rsb, :rsc, :sbc, :sub
          builder = NormalBuilder.new(OPC_DATA_PROCESSING, OPCODES[opcode], s)
          builder.cond = COND_CODES[@cond]
          builder.rd = reg_ref(args[0])
          builder.rn = reg_ref(args[1])
          builder.build_operand args[2] , self.position
          builder.assemble io, as
        when :cmn, :cmp, :teq, :tst
          builder = NormalBuilder.new(OPC_DATA_PROCESSING, OPCODES[opcode], 1)
          builder.cond = COND_CODES[@cond]
          builder.rn = reg_ref(args[0])
          builder.rd = 0
          builder.build_operand args[1]
          builder.assemble io, as
        when :mov, :mvn
          builder = NormalBuilder.new(OPC_DATA_PROCESSING, OPCODES[opcode], s)
          builder.cond = COND_CODES[@cond]
          builder.rn = 0
          builder.rd = reg_ref(args[0])
          builder.build_operand args[1]
          builder.assemble io, as
        when :strb, :str
          builder = MemoryAccessBuilder.new(OPC_MEMORY_ACCESS, (opcode == :strb ? 1 : 0), 0)
          builder.cond = COND_CODES[@cond]
          builder.rd = reg_ref(args[1])
          builder.build_operand args[0]
          builder.assemble io, as, self
        when :ldrb, :ldr
          builder = MemoryAccessBuilder.new(OPC_MEMORY_ACCESS, (opcode == :ldrb ? 1 : 0), 1)
          builder.cond = COND_CODES[@cond]
          builder.rd = reg_ref(args[0])
          builder.build_operand args[1]
          builder.assemble io, as, self
        when :push, :pop
          # downward growing, decrement before memory access
          # official ARM style stack as used by gas
          if (opcode == :push)
            builder = StackBuilder.new(1,0,1,0) 
          else
            builder = StackBuilder.new(0,1,1,1)
          end
          builder.cond = COND_CODES[@cond]
          builder.rn = 13 # sp
          builder.build_operand args
          builder.assemble io, as
        when :b, :bl
          arg = args[0]
          if (arg.is_a?(Asm::NumLiteral))
            jmp_val = arg.value >> 2
            packed = [jmp_val].pack('l')
            # signed 32-bit, condense to 24-bit
            # TODO add check that the value fits into 24 bits
            io << packed[0,3]
          elsif (arg.is_a?(Asm::LabelObject) or arg.is_a?(Asm::Label))
            #not yet tested/supported
#            arg = @ast_asm.object_for_label(arg.label, self) if arg.is_a?(Asm::Label)
#            as.add_relocation(io.tell, arg, Asm::Arm::R_ARM_PC24, RelocHandler)
            #write 0 "for now" and let relocation happen
            io << "\x00\x00\x00"
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
            raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG, arg)
          end
        else
          raise Asm::AssemblyError.new("unknown instruction #{opcode}", @node)
        end
      end
    end
  end
end