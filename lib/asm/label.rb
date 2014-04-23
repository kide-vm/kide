module Asm

  class Label
    def initialize(name , asm)
      @@oh = 1
      @name = name
      @asm = asm
      @position = nil
    end
    
    attr_writer :position , :name

    def position
      if (@position.nil?)
        raise 'Tried to use label object that has not been set'
      end
      @position
    end
    def at pos
      @position = pos
    end
    def length 
      0
    end

    def assemble(io, as)
      self.position = io.tell
    end
    def set!
      @asm.add_value self
      self
    end

  end

end