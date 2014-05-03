require_relative "values"

module Vm
  
  # Think flowcharts: blocks are the boxes. The smallest unit of linear code
  
  # Blocks must end in control instructions (jump/call/return). 
  # And the only valid argument for a jump is a Block 
  
  # Blocks for a double linked list so one can traverse back and forth
  
  # There are four ways for a block to get data (to work on)
  # - hard coded constants (embedded in code)
  # - memory move
  # - values passed in (from previous blocks. ie local variables)

  # See Value description on how to create code/instructions
  
  class Block < Code

    def initialize(name)
      super()
      @name = name.to_sym
      @next = nil
      @previous = nil
      @codes = []
    end

    attr_reader :name , :previous , :next

    def verify
    end

    def add_code(kode)
      kode.at(@position)
      length = kode.length
      puts "length #{length}"
      @position += length
      @codes << kode
    end

    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
    end

    # set the next executed block after self.
    # why is this useful? if it's unconditional, why not merge them:
    #    So the second block can be used as a jump target. You standard loop needs a block to setup
    #    and at least one to do the calculation
    def next block
      block.previous = self
      self.next = block
    end
  end

end