

module Parfait
  # A word is a a short sequence of characters
  # Characters are not modeled as objects but as (small) integers
  # The small means two of them have to fit into a machine word, iw utf16 or similar
  #
  # Words are constant, maybe like js strings, ruby symbols
  # Words are short, but may have spaces
  class Word < Object
    # initialize with length. For now we try to keep all non-parfait (including String) out
    # Virtual provides methods to create Parfait objects from ruby
    def initialize length
      super
      set_length( length , 32 )
    end


    def set_length(len , fill_char)
      return if len < 0
      counter = self.length()
      return if len >= counter
      internal_object_grow( ( len + 1 ) / 2)
      while( counter < len)
        set_char( counter , fill_char)
        counter = counter + 1
      end
    end

    def set_char at , char
      raise "char out of range #{char}" if (char < 0) or (char > 65000)
      index = range_correct_index(at)
      was = internal_object_get(index / 2 )
      if index % 2
        char = (char << 16) + (was & 0xFFFF)
      else
        char = char + (was & 0xFFFF0000)
      end
      internal_object_set( index / 2 , char )
    end

    def get_char at
      index = range_correct_index(at)
      whole = internal_object_get(index / 2 )
      if index % 2
        char = whole >> 16
      else
        char = whole & 0xFFFF
      end
      return char
    end

    def range_correct_index at
      index = at
      index = self.length + at if at < 0
      raise "index out of range #{at}" if index < 0
      return index
    end

    def == other
      return false if other.length != self.length
      len = self.length
      while len
        return false if self.get_char(len) != other.get_char(len)
        len = len - 1
      end
      return true
    end
    
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
