require 'asm/call_instruction'
require 'asm/stack_instruction'
require 'asm/logic_instruction'
require 'asm/memory_instruction'
require 'asm/nodes'
require 'stream_reader'
require 'stringio'
require "asm/string_literal"

module Asm
    
  class ArmAssembler

    ArmMachine::REGISTERS.each do |reg , number|
      define_method(reg) { Asm::Register.new(reg , number) }
    end

    def initialize
      @codes = []
      @position = 0 # marks not set
      @labels = []
      @string_table = {}
    end
    attr_reader  :codes , :position 

    def instruction(clazz, opcode , condition_code , update_status , *args)
      arg_nodes = []
      args.each do |arg|
        if (arg.is_a?(Asm::Register))
          arg_nodes << arg
        elsif (arg.is_a?(Integer))
          arg_nodes << Asm::NumLiteral.new(arg)
        elsif (arg.is_a?(String))
          arg_nodes << add_string(arg)
        elsif (arg.is_a?(Asm::Label))
          arg_nodes << arg
        else
          raise "Invalid argument #{arg.inspect} for instruction"
        end
      end
      add_code clazz.new(opcode , condition_code , update_status , arg_nodes)
    end
    
    
    def self.define_instruction(inst , clazz )
      define_method(inst) do |*args|
        instruction clazz , inst , :al , 0 , *args
      end
      define_method("#{inst}s") do |*args|
        instruction clazz , inst , :al , 1 , *args
      end
      ArmMachine::COND_CODES.keys.each do |suffix|
        define_method("#{inst}#{suffix}") do |*args|
          instruction clazz , inst , suffix , 0 , *args
        end
        define_method("#{inst}s#{suffix}") do |*args|
          instruction clazz , inst , suffix , 1 , *args
        end
      end
    end

    [:push, :pop].each do |inst|
      define_instruction(inst , StackInstruction)
    end

    [:adc, :add, :and, :bic, :eor, :orr, :rsb, :rsc, :sbc, :sub].each do |inst|
      define_instruction(inst , LogicInstruction)
    end
    [:mov, :mvn].each do |inst|
      define_instruction(inst , MoveInstruction)
    end
    [:cmn, :cmp, :teq, :tst].each do |inst|
      define_instruction(inst , CompareInstruction)
    end
    [:strb, :str , :ldrb, :ldr].each do |inst|
      define_instruction(inst , MemoryInstruction)
    end
    [:b, :bl , :swi].each do |inst|
      define_instruction(inst , CallInstruction)
    end
    
    def assemble_to_string
      #put the strings at the end of the assembled code.
      # adding them will fix their position and make them assemble after
      @string_table.values.each do |data|
        add_code data
      end
      io = StringIO.new
      assemble(io)
      io.string
    end

    def add_string str
      code = @string_table[str]
      return code if code
      data = Asm::StringLiteral.new(str)
      @string_table[str] = data
    end
  
    def strings
      @string_table.values
    end
  
    def add_code(kode)
      kode.at(@position)
      length = kode.length
      @position += length
      @codes << kode
    end
  
    def label name
      label = Label.new(name , self)
      @labels << label
      label 
    end

    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
    end

  end
end

