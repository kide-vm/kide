require_relative "values"

module Vm
  
  # Think flowcharts: blocks are the boxes. The smallest unit of linear code
  
  # Blocks must end in control instructions (jump/call/return). 
  # And the only valid argument for a jump is a Block 
  
  # Blocks form a linked list
  
  # There are four ways for a block to get data (to work on)
  # - hard coded constants (embedded in code)
  # - memory move
  # - values passed in (from previous blocks. ie local variables)

  # See Value description on how to create code/instructions
  
  # Blocks have a list of expressions, that they compile into a list of codes
  # Codes then get assembled into bytes (after positioning)
  
  class Block < Code

    def initialize(name)
      super()
      @name = name.to_sym
      @next = nil
      @values = []
      @codes = []
    end

    attr_reader :name  , :next , :codes , :values

    def verify
    end

    def add_value v
      @values << v
    end
    def length
      @codes.inject(0) {| sum  , item | sum + item.length}
    end
    def add_code(kode)
      kode.at(@position)
      length = kode.length
      @position += length
      @codes << kode
      self
    end

    def compile context
      @values.each do |value|
        value.compile(context)
      end
    end
    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
    end

    # all machine methods produce blocks so it's a  unified interface. But often they are just linear 
    # code after linear code, so then they can be joined. 
    # The other block is useless after, all instructions move here  
    def join other
      raise "block is chained already, can't join #{inspect}" if @next
      other.codes.each do |code|
        add_code code
      end
      other.values.each do |value|
        add_value value
      end
      self
    end
    # set the next executed block after self.
    # why is this useful? if it's unconditional, why not merge them:
    #    So the second block can be used as a jump target. You standard loop needs a block to setup
    #    and at least one to do the calculation
    def next block
      @next = block
    end

  end

end