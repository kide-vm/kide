require "asm/assembly_error"
require "asm/arm/instruction_tools"
require "asm/arm/builder_a"
require "asm/arm/builder_b"
require "asm/arm/builder_d"

module Asm
  module Arm

    class Instruction
      include InstructionTools

      COND_POSTFIXES = Regexp.union(%w(eq ne cs cc mi pl vs vc hi ls ge lt gt le al)).source
      def initialize(node, ast_asm = nil)
        @node = node
        @ast_asm = ast_asm
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
      attr_reader :opcode, :args

      def affect_status
        @s
      end

      OPC_DATA_PROCESSING = 0b00
      OPC_MEMORY_ACCESS = 0b01
      OPC_STACK = 0b10
      # These are used differently in the
      # instruction encoders
      OPCODES = {
        :adc => 0b0101, :add => 0b0100,
        :and => 0b0000, :bic => 0b1110,
        :eor => 0b0001, :orr => 0b1100,
        :rsb => 0b0011, :rsc => 0b0111,
        :sbc => 0b0110, :sub => 0b0010,

        # for these Rn is sbz (should be zero)
        :mov => 0b1101,
        :mvn => 0b1111,
        # for these Rd is sbz and S=1
        :cmn => 0b1011,
        :cmp => 0b1010,
        :teq => 0b1001,
        :tst => 0b1000,

        :b => 0b1010,
        :bl => 0b1011,
        :bx => 0b00010010
      }
      COND_BITS = {
        :al => 0b1110, :eq => 0b0000,
        :ne => 0b0001, :cs => 0b0010,
        :mi => 0b0100, :hi => 0b1000,
        :cc => 0b0011, :pl => 0b0101,
        :ls => 0b1001, :vc => 0b0111,
        :lt => 0b1011, :le => 0b1101,
        :ge => 0b1010, :gt => 0b1100,
        :vs => 0b0110
      }

      RelocHandler = Asm::Arm.method(:write_resolved_relocation)

      def assemble(io, as)
        s = @s ? 1 : 0
        case opcode
        when :adc, :add, :and, :bic, :eor, :orr, :rsb, :rsc, :sbc, :sub
          a = BuilderA.make(OPC_DATA_PROCESSING, OPCODES[opcode], s)
          a.cond = COND_BITS[@cond]
          a.rd = reg_ref(args[0])
          a.rn = reg_ref(args[1])
          a.build_operand args[2]
          a.write io, as
        when :cmn, :cmp, :teq, :tst
          a = BuilderA.make(OPC_DATA_PROCESSING, OPCODES[opcode], 1)
          a.cond = COND_BITS[@cond]
          a.rn = reg_ref(args[0])
          a.rd = 0
          a.build_operand args[1]
          a.write io, as
        when :mov, :mvn
          a = BuilderA.make(OPC_DATA_PROCESSING, OPCODES[opcode], s)
          a.cond = COND_BITS[@cond]
          a.rn = 0
          a.rd = reg_ref(args[0])
          a.build_operand args[1]
          a.write io, as
        when :strb, :str
          a = BuilderB.make(OPC_MEMORY_ACCESS, (opcode == :strb ? 1 : 0), 0)
          a.cond = COND_BITS[@cond]
          a.rd = reg_ref(args[1])
          a.build_operand args[0]
          a.write io, as, @ast_asm, self
        when :ldrb, :ldr
          a = BuilderB.make(OPC_MEMORY_ACCESS, (opcode == :ldrb ? 1 : 0), 1)
          a.cond = COND_BITS[@cond]
          a.rd = reg_ref(args[0])
          a.build_operand args[1]
          a.write io, as, @ast_asm, self
        when :push, :pop
          # downward growing, decrement before memory access
          # official ARM style stack as used by gas
          if (opcode == :push)
            a = BuilderD.make(1,0,1,0) 
          else
            a = BuilderD.make(0,1,1,1)
          end
          a.cond = COND_BITS[@cond]
          a.rn = 13 # sp
          puts "ARGS #{args.inspect}"
          a.build_operand args
          a.write io, as
        when :b, :bl
          arg = args[0]
          if (arg.is_a?(Asm::NumLiteralArgNode))
            jmp_val = arg.value >> 2
            packed = [jmp_val].pack('l')
            # signed 32-bit, condense to 24-bit
            # TODO add check that the value fits into 24 bits
            io << packed[0,3]
          elsif (arg.is_a?(Asm::LabelObject) or arg.is_a?(Asm::LabelRefArgNode))
            arg = @ast_asm.object_for_label(arg.label, self) if arg.is_a?(Asm::LabelRefArgNode)
            as.add_relocation(io.tell, arg, Asm::Arm::R_ARM_PC24, RelocHandler)
            io << "\x00\x00\x00"
          end
          io.write_uint8 OPCODES[opcode] | (COND_BITS[@cond] << 4)
        when :bx
          rm = reg_ref(args[0])
          io.write_uint32 rm | (0b1111111111110001 << 4) | (OPCODES[:bx] << 16+4) |
                          (COND_BITS[@cond] << 16+4+8)
        when :swi
          arg = args[0]
          if (arg.is_a?(Asm::NumLiteralArgNode))
            packed = [arg.value].pack('L')[0,3]
            io << packed
            io.write_uint8 0b1111 | (COND_BITS[@cond] << 4)
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