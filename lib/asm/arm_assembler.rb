require 'asm/instruction'
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

      def instruction(clazz,name, *args)
        opcode = name.to_s
        arg_nodes = []

        args.each { |arg|
          if (arg.is_a?(Asm::Register))
            arg_nodes << arg
          elsif (arg.is_a?(Integer))
            arg_nodes << Asm::NumLiteral.new(arg)
          elsif (arg.is_a?(String))
            arg_nodes << add_string(arg)
          elsif (arg.is_a?(Asm::Label))
            arg_nodes << arg
          else
            raise 'Invalid argument `%s\' for instruction' % arg.inspect
          end
        }

        add_value clazz.new(opcode , arg_nodes)
      end
      
      
      def self.define_instruction(inst , clazz )
        define_method(inst) do |*args|
          instruction clazz , inst.to_sym, *args
        end
        define_method(inst+'s') do |*args|
          instruction clazz , (inst+'s').to_sym, *args
        end
        %w(al eq ne cs mi hi cc pl ls vc lt le ge gt vs).each do |cond_suffix|
          define_method(inst+cond_suffix) do |*args|
            instruction clazz , (inst+cond_suffix).to_sym, *args
          end
          define_method(inst+'s'+cond_suffix) do |*args|
            instruction clazz , (inst+'s'+cond_suffix).to_sym, *args
          end
        end
      end

      ["push", "pop"].each do |inst|
        define_instruction(inst , StackInstruction)
      end

      %w(adc add and bic eor orr rsb rsc sbc sub mov mvn cmn cmp teq tst b bl bx 
         swi str strb ldr ldrb  ).each do |inst|
        define_instruction(inst , Instruction)
      end

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
    
      def label name
        label = Label.new(name , self)
        @labels << label
        label 
      end

      def label! name
        label(name).set!
      end

      def assemble(io)
        @values.each do |obj|
          obj.assemble io, self
        end
      end

    end
end

