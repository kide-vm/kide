

module Parfait
  # A word is a a short sequence of characters
  # Characters are not modeled as objects but as (small) integers
  # The small means two of them have to fit into a machine word, iw utf16 or similar
  #
  # Words are constant, maybe like js strings, ruby symbols
  # Words are short, but may have spaces
  class Word < Object
    def initialize str
      @string = str
    end
    attr_reader :string

    def result= value
      raise "called"
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
    end
    def clazz
      Space.space.get_or_create_class(:Word)
    end
    def layout
      Virtual::Object.layout
    end
    def mem_length
      padded(1 + string.length)
    end
    def position
      return @position if @position
      return @string.position if @string.position
      super
    end
  end
end
