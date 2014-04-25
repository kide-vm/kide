require 'asm/nodes'
require 'asm/block'
require 'stream_reader'
require 'stringio'
require "asm/string_literal"

module Asm
  
  # Program is the the top-level of the code hierachy, except it is not derived from code
  # instead a Program is a list of blocks (and string constants)
  
  # All code is created in blocks (see there) and there are two styles for that, for forward of backward
  # referencing. Read function block and add_block and Block.set
  
  
  class Program

    def initialize
      @blocks = []
      @string_table = {}
    end

    attr_reader  :blocks 

    # Assembling to string will return a binary string of the whole program, ie all blocks and the 
    # strings they use
    # As a memory reference this would be callable, but more likely you will hand it over to 
    # an ObjectWriter as the .text section and then link it. And then execute it :-)
    def assemble_to_string
      #put the strings at the end of the assembled code.
      # adding them will fix their position and make them assemble after
      @string_table.values.each do |data|
        add_block data
      end
      io = StringIO.new
      assemble(io)
      io.string
    end

    # Add a string to the string table. Strings are global and constant. So only one copy of each 
    # string exists
    # Internally StringLiterals are created and stored and during assembly written after the blocks
    def add_string str
      code = @string_table[str]
      return code if code
      data = Asm::StringLiteral.new(str)
      @string_table[str] = data
    end

    # Length of all blocks. Does not take strings into account as they are added after all blocks.
    # This is used to determine where a block when it is added after creation (see add_block)
    def length
      @blocks.inject(0) {| sum  , item | sum + item.length}
    end

    # call block to create a new (code) block. The simple way is to do this with a block and 
    # use the yielded block to add code, ie something like:
    #   prog.block do |loop|
    #         loop.instance_eval do           #this part you can acheive with calls too
    #                   mov r0 , 10
    #                   subs r0 , 1
    #                   bne block
    #         end
    #   end
    # Easy, because it's a backward jump. For forward branches that doesn't work and so you have to 
    # create the block without a ruby block. You can then jumpt to it immediately
    # But the block is not part of the program (since we don't know where) and so you have to add it later
    def block
      block = Block.new(self)
      yield block.set! if block_given? #yield the block (which set returns)
      block
    end

    # This is how you add a forward declared block. This is called automatically when you 
    # call block with ruby block, but has to be done manually if not
    def add_block block
      block.at self.length
      @blocks << block
    end

    private
    
    def assemble(io)
      @blocks.each do |obj|
        obj.assemble io
      end
    end
  end
end

