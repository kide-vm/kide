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
  
  # Codes then get assembled into bytes (after linking)
  
  class Block < Code

    def initialize(name)
      super()
      @name = name.to_sym
      @next = nil
      @codes = []
    end

    attr_reader :name  , :next , :codes

    def length
      @codes.inject(0) {| sum  , item | sum + item.length}
    end

    def add_code(kode)
      if kode.is_a? Hash
        raise "Hack only for 1 element #{inspect} #{kode.inspect}" unless kode.length == 1
        instruction , result = kode.first
        instruction.result = result
        kode = instruction
      end
      raise "alarm #{kode}" if kode.is_a? Word
      raise "alarm #{kode}" unless kode.is_a? Code
      @codes << kode
      self
    end
    alias :<< :add_code 
    alias :a :add_code 

    def link_at pos , context
      @position = pos
      @codes.each do |code|
        code.link_at(pos , context)
        pos += code.length
      end
      pos
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
    def set_next block
      @next = block
    end

    # sugar to create instructions easily. Any method with one arg is sent to the machine and the result
    # (hopefully an instruction) added as code
    def method_missing(meth, *args, &block)
      raise "hallo" if( meth.to_s[-1] == "=")
      add_code CMachine.instance.send(meth , *args)
    end

  end

end