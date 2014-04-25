require_relative 'call_instruction'
require_relative 'stack_instruction'
require_relative 'logic_instruction'
require_relative 'memory_instruction'

module Asm
  
  class Code ; end
  
  # A Block is the smalles unit of code, a list of instructions as it were
  # It is also a point to jump/branch to. An address in the final stream.
  # To allow for forward branches creation does not fix the position. Either set or assembling does that.

  # Blocks are also used to create instructions, and so Block has functions for every cpu instruction
  # and to make using the apu function easier, there are functions that create registers as well
  class Block < Code
    extend Forwardable  # forward block call back to program
    def_delegator :@program, :block

    def initialize(asm)
      super()
      @codes = []
      @position = 0
      @program = asm
    end

    ArmMachine::REGISTERS.each do |reg , number|
      define_method(reg) { Asm::Register.new(reg , number) }
    end

    def instruction(clazz, opcode , condition_code , update_status , *args)
      arg_nodes = []
      args.each do |arg|
        if (arg.is_a?(Asm::Register))
          arg_nodes << arg
        elsif (arg.is_a?(Integer))
          arg_nodes << Asm::NumLiteral.new(arg)
        elsif (arg.is_a?(String))
          arg_nodes << @program.add_string(arg)
        elsif (arg.is_a?(Asm::Block))
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

    # setting a block fixes it's position in the stream. 
    # For backwards jumps, positions of blocks are known at creation, but for forward off course not.
    # So then one can create a block, branch to it and set it later. 
    def set!
      @program.add_block self
      self
    end

    # length of the codes. In arm it would be the length * 4
    # (strings are stored globally in the Program)
    def length 
      @codes.inject(0) {| sum  , item | sum + item.length}
    end

    def add_code(kode)
      kode.at(@position)
      length = kode.length
      @position += length
      @codes << kode
    end

    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
    end

  end

end