

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
    # String will contain spaces for non-zero length
    # Virtual provides methods to create Parfait objects from ruby
    def initialize len
      super()
      raise "Must init with int, not #{len.class}" unless len.kind_of? Fixnum
      raise "Must init with positive, not #{len}" if len < 0
      set_length( len , 32 ) unless len == 0
    end

    # return a copy of self
    def copy
      cop = Word.new( self.length )
      index = 1
      while( index <= self.length )
        cop.set_char(index , self.get_char(index))
        index = index + 1
      end
      cop
    end

    # return the number of characters
    def length()
      obj_len = internal_object_length - 1
      return obj_len
    end

    # make every char equal the given one
    def fill_with char
      fill_from_with(0 , char)
    end

    def fill_from_with from , char
      len = self.length()
      return if from <= 0
      while( from <= len)
        set_char( from , char)
        from = from + 1
      end
      from
    end

    # true if no characters
    def empty?
      return self.length == 0
    end

    # pad the string with the given character to the given length
    #
    def set_length(len , fill_char)
      return if len <= 0
      counter = self.length()
      return if counter >= len
      internal_object_grow( len + 1)
      fill_from_with( counter + 1 , fill_char )
    end

    # set the character at the given index to the given character
    # character must be an integer, as is the index
    # the index starts at one, but may be negative to count from the end
    # indexes out of range will raise an error
    def set_char at , char
      raise "char not fixnum #{char}" unless char.kind_of? Fixnum
      index = range_correct_index(at)
      internal_object_set( index + 1  , char )
    end

    # get the character at the given index
    # the index starts at one, but may be negative to count from the end
    # indexes out of range will raise an error
    #the return "character" is an integer
    def get_char at
      index = range_correct_index(at)
      return internal_object_get(index + 1)
    end

    # private method to calculate negative indexes into positives
    def range_correct_index at
      index = at
      index = self.length + at if at < 0
      raise "index must be positive , not #{at}" if (index <= 0)
      raise "index too large #{at} > #{self.length}" if (index > self.length)
      return index
    end

    # compare the word to another
    # currently checks for same class, though really identity of the characters
    # in right order would suffice
    def == other
      return false if other.class != self.class
      return false if other.length != self.length
      len = self.length
      while(len > 0)
        return false if self.get_char(len) != other.get_char(len)
        len = len - 1
      end
      return true
    end

    # this is a sof check if there are instance variables or "structure"
    def is_value?
      true
    end

    # as we answered is_value? with true, sof will create a basic node with this string
    def to_sof
      "'" + to_s + "'"
    end

    #below here is OLD, DUBIOUS and needs to be checked TODO
    def result= value
      raise "called"
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
    end
    def word_length
      (string.length+1) / 4
    end
  end
end
