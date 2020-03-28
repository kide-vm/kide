

module Parfait
  # A word is a a short sequence of characters
  # Characters are not modeled as objects but as (small) integers
  # The small means two of them have to fit into a machine word, utf16 or similar
  #
  # Words are constant, maybe like js strings, ruby symbols
  # Words are short, but may have spaces

  # Words are objects, that means they carry Type as index 0
  # So all indexes are offset by one in the implementation
  # Object length is measured in non-type cells though

  class Word < Data8
    attr_reader :char_length ,:next_word


    def self.type_length
      3    # 0 type , 1 char_length , next_word
    end
    def self.get_length_index
      type_length - 2
    end
    # initialize with length. For now we try to keep all non-parfait (including String) out
    # String will contain spaces for non-zero length
    # Risc provides methods to create Parfait objects from ruby
    def initialize( len )
      super()
      @char_length = 0
      #@str=str1
      #@prefix=prefix1
      raise "Must init with int, not #{len.class}" unless len.kind_of? ::Integer
      raise "Must init with positive, not #{len}" if len < 0
      fill_to( len , 32 ) unless len == 0 #32 being ascii space
      #puts "type #{self.get_type} #{self.object_id.to_s(16)}"
    end


    # return a copy of self
    def copy
      cop = Word.new( @char_length )
      index = 0
      while( index < @char_length )
        cop.set_char(index , get_char(index))
        index = index + 1
      end
      cop
    end

    # return the number of characters
    def length()
      @char_length
    end

    # make every char equal the given one
    def fill_with( char )
      fill_from_with(0 , char)
    end

    def fill_from_with( from , char )
      len = @char_length
      return if from < 0
      while( from < len)
        set_char( from , char)
        from = from + 1
      end
      from
    end

    # true if no characters
    def empty?
      return @char_length == 0
    end

    # pad the string with the given character to the given length
    #
    def fill_to(len , fill_char)
      return if len <= 0
      old = @char_length
      return if old >= len
      @char_length = len
      check_length
      fill_from_with( old  , fill_char )
    end

    # set the character at the given index to the given character
    # character must be an integer, as is the index
    # the index starts at one, but may be negative to count from the end
    # indexes out of range will raise an error
    def set_char( at , char )
      raise "char not fixnum #{char.class}" unless char.kind_of? ::Integer
      index = range_correct_index(at)
      set_internal_byte( index , char)
    end

    def set_internal_byte( index , char )
      word_index = (index) / 4
      rest = ((index) % 4)
      shifted =  char << (rest * 8)
      was = get_internal_word( word_index )
      was = 0 unless was.is_a?(Numeric)
      mask = 0xFF << (rest * 8)
      mask = 0xFFFFFFFF - mask
      masked = was & mask
      put = masked + shifted
      set_internal_word( word_index , put )
      msg = "set index=#{index} word_index=#{word_index} rest=#{rest}= "
      msg += "char=#{char.to_s(16)} shifted=#{shifted.to_s(16)} "
      msg += "was=#{was.to_s(16)} masked=#{masked.to_s(16)} put=#{put.to_s(16)}"
      #puts msg
      char
    end

    # get the character at the given index (lowest 1)
    # the index starts at one, but may be negative to count from the end
    # indexes out of range will raise an error
    #the return "character" is an integer
    def get_char( at )
      index = range_correct_index(at)
      get_internal_byte(index)
    end


    def get_internal_byte( index )
      word_index = (index ) / 4
      rest = ((index) % 4)
      char = get_internal_word(word_index)
      char = 0 unless char.is_a?(Numeric)
      shifted = char >> (8 * rest)
      ret = shifted & 0xFF
      msg = "get index=#{index} word_index=#{word_index} rest=#{rest}= "
      msg += " char=#{char.to_s(16)} shifted=#{shifted.to_s(16)}  ret=#{ret.to_s(16)}"
      #puts msg
      return ret
    end

    # private method to account for
    def range_correct_index( at )
      index = at
#      index = self.length + at if at < 0
      raise "index not integer #{at.class}" unless at.is_a?(::Integer)
      raise "index must be positive , not #{at}" if (index < 0)
      raise "index too large #{at} > #{self.length}" if (index >= self.length )
      return index + Word.type_length * 4
    end

    # compare the word to another
    # currently checks for same class, though really identity of the characters
    # in right order would suffice
    def compare( other )
      return false if other.class != self.class
      return false if other.length != self.length
      len = self.length - 1
      while(len >= 0)
        return false if self.get_char(len) != other.get_char(len)
        len = len - 1
      end
      return true
    end

    def == other
      return false unless other.is_a?(String) or other.is_a?(Word)
      as_string = self.to_string
      unless other.is_a? String
        other = other.to_string
      end
      as_string == other
    end

    def to_string
      string = ""
      index = 0
      #puts "Length = #{char_length}"
      while( index < @char_length)
        char = get_char(index)
        string += char ? char.chr : "*"
        index = index + 1
      end
      string
    end

    # as we answered is_value? with true, rfx will create a basic node with this string
    def to_rfx
      "'" + to_s + "'"
    end

    def to_s
      "Word:#{to_string}"
    end

    def padded_length
      Object.padded( 4 * get_type().instance_length + @char_length  )
    end
    def start_with(other)
      return false if other.length > self.length
        s = other.length
        temp = Word.new(other.length)
        i=0
        while i<=s-1
          temp.set_char(i,self.get_char(i))
          if temp.compare(other)
            return true
          end
          i=i+1
        end
        return false
      end
    private
    def check_length
      raise "Length out of bounds #{char_length}" if @char_length > 1000
    end
  end

end
