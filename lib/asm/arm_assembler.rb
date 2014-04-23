require 'asm/arm_assembler'
require 'asm/instruction'
require 'asm/generator_label'
require 'asm/nodes'
require 'stream_reader'
require 'stringio'
require "asm/string_literal"

module Asm
    
    class ArmAssembler

      %w(r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12
         r13 r14 r15 a1 a2 a3 a4 v1 v2 v3 v4 v5 v6
         rfp sl fp ip sp lr pc
      ).each { |reg|
        define_method(reg) {
          Asm::Register.new(reg)
        }
      }

      def initialize
        @values = []
        @position = 0 # marks not set
        @labels = []
        @string_table = {}
      end
      attr_reader  :values , :position 

      def instruction(name, *args)
        opcode = name.to_s
        arg_nodes = []

        args.each { |arg|
          if (arg.is_a?(Asm::Register))
            arg_nodes << arg
          elsif (arg.is_a?(Integer))
            arg_nodes << Asm::NumLiteral.new(arg)
          elsif (arg.is_a?(String))
            arg_nodes << add_string(arg)
          elsif (arg.is_a?(Symbol))
            arg_nodes << Asm::Label.new(arg.to_s)
          elsif (arg.is_a?(Asm::GeneratorLabel))
            arg_nodes << arg
          else
            raise 'Invalid argument `%s\' for instruction' % arg.inspect
          end
        }

        add_value Asm::Instruction.new(opcode , arg_nodes)
      end

      %w(adc add and bic eor orr rsb rsc sbc sub mov mvn cmn cmp teq tst b bl bx 
        push pop swi str strb ldr ldrb 
      ).each { |inst|
        define_method(inst) { |*args|
          instruction inst.to_sym, *args
        }
        define_method(inst+'s') { |*args|
          instruction (inst+'s').to_sym, *args
        }
        %w(al eq ne cs mi hi cc pl ls vc lt le ge gt vs
        ).each { |cond_suffix|
          define_method(inst+cond_suffix) { |*args|
            instruction (inst+cond_suffix).to_sym, *args
          }
          define_method(inst+'s'+cond_suffix) { |*args|
            instruction (inst+'s'+cond_suffix).to_sym, *args
          }
        }
      }

      def assemble_to_string
        #put the strings at the end of the assembled code.
        # adding them will fix their position and make them assemble after
        @string_table.values.each do |data|
          add_value data
        end
        io = StringIO.new
        assemble(io)
        io.string
      end

      def add_string str
        value = @string_table[str]
        return value if value
        data = Asm::StringLiteral.new(str)
        @string_table[str] = data
      end
    
      def strings
        @string_table.values
      end
    
      def add_value(val)
        val.at(@position)
        length = val.length
        @position += length
        @values << val
      end
    
      def label
        label = Asm::GeneratorLabel.new(self)
        @labels << label
        label 
      end

      def label!
        label.set!
      end

      def assemble(io)
        @values.each do |obj|
          obj.assemble io, self
        end
      end

    end

    # Relocation constants
    # Note that in this assembler, a relocation simply means any
    # reference to a label that can only be determined at assembly time
    # or later (as in the normal meaning)
  
    R_ARM_PC24 = 0x01
    R_ARM_ABS32 = 0x02
  
    # Unofficial (cant be used for extern relocations)
    R_ARM_PC12 = 0xF0
  
    def self.write_resolved_relocation(io, addr, type)
      case type
      when R_ARM_PC24
        diff = addr - io.tell - 8
        if (diff.abs > (1 << 25))
          raise Asm::AssemblyError.new('offset too large for R_ARM_PC24 relocation')
        end
        packed = [diff >> 2].pack('l')
        io << packed[0,3]
      when R_ARM_ABS32
        packed = [addr].pack('l')
        io << packed
      when R_ARM_PC12
        diff = addr - io.tell - 8
        if (diff.abs > 2047)
          raise Asm::AssemblyError.new('offset too large for R_ARM_PC12 relocation')
        end
      
        val = diff.abs
        sign = (diff>0)?1:0
      
        curr = io.read_uint32
        io.seek(-4, IO::SEEK_CUR)
      
        io.write_uint32 (curr & ~0b00000000100000000000111111111111) | 
                        val | (sign << 23)
      else
        raise 'unknown relocation type'
      end
    end
end

