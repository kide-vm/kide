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
      extend_to(total_size)
      #puts "Init with #{total_size} for #{object_id}"
      (1..(data_length+1)).each{ |index| set_word(index , 0) }
    end
    def extend_to(total_size)
      if total_size > self.data_length
        @next = BinaryCode.new(total_size - data_length)
      end
    end
    def to_s
      "BinaryCode #{}"
    end
    #16 - 2 -1 , two instance varaibles and one for the jump
    def data_length
      13
    end
    def byte_length
      4*data_length
    end
    def set_word(index , word)
      raise "invalid index #{index}" if index < 1
      if index > data_length + 1
        raise "invalid index #{index}" unless @next
        @next.set_word( index - data_length , word)
      end
      set_internal_word(index + 2 , word)
    end
    def get_word(index)
      raise "invalid index #{index}" if index < 1
      if index > data_length + 1
        raise "invalid index #{index}" unless @next
        return @next.get_word( index - data_length)
      end
      get_internal_word(index + 2)
    end
    def set_char(index , char)
      if index >= byte_length
        #puts "Pass it on #{index} for #{self.object_id}:#{@next.object_id}"
        return @next.set_char( index - byte_length ,  char )
      end
      word_index = (index - 1) / 4 + 2
      old = get_internal_word( word_index )
      old = old && char << ((index-1)%4)
      set_internal_word(word_index , char)
    end
    def total_byte_length(start = 0 )
      start += self.byte_length
      return start unless self.next
      self.next.total_byte_length(start)
    end
  end
end
