require 'arm/nodes'
require 'vm/block'
require 'stream_reader'
require 'stringio'
require "arm/string_literal"

module Arm
  
  # Assembler is the the top-level of the code hierachy, except it is not derived from code
  # instead a Assembler is a list of blocks (and string constants)
  
  # All code is created in blocks (see there) and there are two styles for that, for forward of backward
  # referencing. Read function block and add_block and Block.set
  
  
  class Bassembler #eol warning!

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
    # Internally StringConstants are created and stored and during assembly written after the blocks
    def add_string str
      code = @string_table[str]
      return code if code
      data = Virtual::StringConstant.new(str)
      @string_table[str] = data
    end

    # Length of all blocks. Does not take strings into account as they are added after all blocks.
    # This is used to determine where a block when it is added after creation (see add_block)
    def length
      @blocks.inject(0) {| sum  , item | sum + item.mem_length}
    end

    # This is how you add a forward declared block. This is called automatically when you 
    # call block with ruby block, but has to be done manually if not
    def add_block block
      block.at self.mem_length
      @blocks << block
    end

    # return the block of the given name
    # or raise an exception, as this is meant to be called when the block is available 
    def get_block name
      name = name.to_sym
      block = @blocks.find {|b| b.name == name}
      raise "No block found for #{name} (in #{blocks.collect{|b|b.name}.join(':')})" unless block
      block
    end
    # this is used to create blocks. 
    # All functions that have no args are interpreted as block names
    # and if a block is provided, it is evaluated in the (ruby)blocks scope and the block added to the 
    # program immediately. 
    # If no block is provided (forward declaration), you must call code on it later 
    def method_missing(meth, *args, &block)
      if args.length == 0
        code = Block.new(meth.to_s , self )
        if block_given?
          add_block code
          code.instance_eval(&block)
        end
        return code
      else
        super
      end
    end
    

    private
    
    def assemble(io)
      @blocks.each do |obj|
        obj.assemble io
      end
    end
  end
end

