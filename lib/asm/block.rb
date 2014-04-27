require_relative 'call_instruction'
require_relative 'stack_instruction'
require_relative 'logic_instruction'
require_relative 'memory_instruction'

module Asm
  
  class Code ; end
  
  # A Block is the smalles unit of code, a list of instructions as it were
  # It is also a point to jump/branch to. An address in the final stream.
  # To allow for forward branches creation does not fix the position. 
  # Thee position is fixed in one of three ways
  # - create the block with ruby block, signalling that the instantiation poin is the position
  # - call block.code with the code or if you wish program.add_block (and add you code with calls)
  # - the assmebly process will pin it if it wasn't set

  # creating blocks is done by calling the blocks name/label on either a program or a block
  #  (method missing will cathc the call and create the block)
  # and the easiest way is to go into a ruby block and start writing instructions
  # Example (backward jump):
  #       program.loop do                         create a new block with label loop
  #                 sub r1 , r1 , 1               count the r1 register down
  #                 bne :loop                     jump back to loop when the counter is not zero
  #       end                                    (initialization and actual code missing off course)
  
  # Example (forward jump)
  #       else_block = program.else
  #       program.if do
  #                  test r1 , 0                  test some condition
  #                  beq :else_block
  #                   mov . . .. ..               do whatever the if block does
  #       end
  #       else_block.code do
  #                      ldr ....                 do whatever else does
  #       end
  
  # Blocks are also used to create instructions, and so Block has functions for every cpu instruction
  # and to make using the apu function easier, there are functions that create registers as well
  class Block < Code

    def initialize(name , prog)
      super()
      @name = name.to_sym
      @codes = []
      @position = 0
      @program = prog
    end
    attr_reader :name

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
        elsif (arg.is_a?(Symbol))
          block = @program.get_block arg
          arg_nodes << block
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

    # codeing a block fixes it's position in the stream. 
    # You must call with a block, which is instance_eval'd and provides the actual code for the block
    def code &block
      @program.add_block self
      self.instance_eval block 
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

    # this is used to create blocks. 
    # All functions that have no args are interpreted as block names
    # In fact the block calls are delegated to the program which then instantiates the blocks
    def method_missing(meth, *args, &block)
      if args.length == 0
        @program.send(meth , *args , &block)
      else
        super
      end
    end

  end

end