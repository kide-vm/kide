module Parfait

  # A typed method object is a description of the method, it's name etc
  #
  # But the code that the method represents, the binary, is held as an array
  # in these. As Objects are fixed size (this one 16 words), we use  linked list
  # and as the last code of each link is a jump to the next link.
  #
  class BinaryCode < Data16
    attr_reader :next

    def initialize(total_size)
      super()
      if total_size > self.data_length
        @next = BinaryCode.new(total_size - data_length - 1) #one for the jump
      end
      #puts "Init with #{total_size} for #{object_id}"
    end
    def to_s
      "BinaryCode #{}"
    end
    def data_length
      14
    end
    def byte_length
      4*data_length
    end
    def set_char(index , char)
      if index >= byte_length
        puts "Pass it on #{index} for #{object_id}"
        return @next.set_char( char , index - byte_length)
      end
      word_index = (index - 1) / 4 + 2
      old = get_internal_word( word_index )
      old = old && char << ((index-1)%4)
      set_internal_word(word_index , char)
    end
    def total_byte_length(start = 0 )
      start += 4*14
      return start unless self.next
      self.next.total_byte_length(start)
    end
  end
end
