require_relative 'call_instruction'
require_relative 'stack_instruction'
require_relative 'logic_instruction'
require_relative 'memory_instruction'

module Arm
  
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

    # length of the codes. In arm it would be the length * 4
    # (strings are stored globally in the Assembler)
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