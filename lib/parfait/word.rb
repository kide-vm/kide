

module Parfait
  # A word is a a short sequence of characters
  # Characters are not modeled as objects but as (small) integers
  # The small means two of them have to fit into a machine word, iw utf16 or similar
  #
  # Words are constant, maybe like js strings, ruby symbols
  # Words are short, but may have spaces

  # Words are objects, that means they carry Layout as index 0
  # So all indexes are offset by one in the implementation
  # Object length is measured in non-layout cells though

  # big TODO , this has NO encoding, a char takes a machine word. Go fix.
  class Word < Object
    # initialize with length. For now we try to keep all non-parfait (including String) out
    # Virtual provides methods to create Parfait objects from ruby
    def initialize len
      super()
      raise "Must init with int, not #{len.class}" unless len.kind_of? Fixnum
      raise "Must init with positive, not #{len}" if len < 0
      set_length( len , 32 ) unless len == 0
    end

    def length()
      obj_len = internal_object_length - 1
      return obj_len
    end

    def empty?
      return self.length == 0
    end

    def set_length(len , fill_char)
      return if len <= 0
      counter = self.length()
      return if counter >= len
      internal_object_grow( len + 1)
      while( counter < len)
        set_char( counter , fill_char)
        counter = counter + 1
      end
    end

    def set_char at , char
      raise "char not fixnum #{char}" unless char.kind_of? Fixnum
      index = range_correct_index(at)
      internal_object_set( index + 1  , char )
    end

    def get_char at
      index = range_correct_index(at)
      return internal_object_get(index + 1)
    end

    def range_correct_index at
      index = at
      index = self.length + at if at < 0
      raise "index out of bounds #{at} > #{self.length}" if (index < 0) or (index > self.length)
      return index
    end

    def == other
      return false if other.class != self.class
      return false if other.length != self.length
      len = self.length
      while(len >= 0)
        return false if self.get_char(len) != other.get_char(len)
        len = len - 1
      end
      return true
    end

    def is_value?
      true
    end
    def to_sof
      "Parfait::Word('#{to_s}')"
    end
    def result= value
      raise "called"
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
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
