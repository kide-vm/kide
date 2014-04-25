require_relative "code"

module Asm
  
  # Labels are, like in assembler, a point to jump/branch to. An address in the stream.
  # To allow for forward branches creation does not fix the position. Set does that.
  class Label < Code
    def initialize(name , asm)
      super
      @name = name
      @asm = asm
    end

    # setting a label fixes it's position in the stream. 
    # For backwards jumps, positions of labels are known at creation, but for forward off course not.
    # So then one can create a label, branch to it and set it later. 
    def set!
      @asm.add_value self
      self
    end

    # Label has no length , 0
    def length 
      0
    end

    # nothing to write, we check that the position is what was set
    def assemble(io)
      raise "Hmm hmm hmm, me thinks i should be somewhere else" if self.position != io.tell
    end

  end

end