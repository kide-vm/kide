module Parfait

  # A typed method object is a description of the method, it's name etc
  #
  # But the code that the method represents, the binary, is held as an array
  # in these. As Objects are fixed size (this one 16 words), we use  linked list
  # and as the last code of each link is a jump to the next link.
  #
  class BinaryCode < Data32
    attr_reader :next_code

    def self.type_length
      2 #type + next (could get from space, maybe later)
    end
    def self.byte_offset
      self.type_length * 4 # size of type * word_size (4)
    end
    def self.data_length
      self.memory_size - self.type_length - 1 #one for the jump
    end
    def data_length
      self.class.data_length
    end
    def byte_length
      4*data_length
    end

    def initialize(total_size)
      super()
      @next_code = nil
      extend_to(total_size )
      (0 ... data_length).each{ |index| set_word(index , 0) }
      set_last(0)
    end

    def extend_to(total_size)
      return if total_size < data_length
      extend_one() unless next_code
      next_code.extend_to(total_size - data_length)
    end

    def extend_one()
      @next_code = BinaryCode.new(1)
      Risc::Position.get(self).trigger_inserted if Risc::Position.set?(self)
    end

    def ensure_next
      extend_one unless next_code
      next_code
    end

    def last_code
      last = self
      last = last.next_code while(last.next_code)
      last
    end

    def each_block( &block )
      block.call( self )
      next_code.each_block( &block ) if next_code
    end

    def to_s
      "BinaryCode #{Risc::Position.set?(self) ? Risc::Position.get(self): self.object_id.to_s(16)}"
    end

    def each_word( all = true)
      index = 0
      while( index < data_length)
        yield get_word(index)
        index += 1
      end
      yield( get_last ) if all
    end

    def set_word(index , word)
      raise "invalid index #{index}" if index < 0
      if index >= data_length
        #raise "invalid index #{index}" unless next
        extend_to( index )
        next_code.set_word( index - data_length , word)
      else
        set_internal_word(index + BinaryCode.type_length , word)
      end
    end
    def get_last()
      get_internal_word(data_length + BinaryCode.type_length)
    end
    def set_last(word)
      set_internal_word(data_length + BinaryCode.type_length , word)
    end
    def get_word(index)
      raise "invalid index #{index}" if index < 0
      if index >= data_length
        raise "invalid index #{index}" unless next_code
        return next_code.get_word( index - data_length)
      end
      get_internal_word(index + BinaryCode.type_length)
    end
    def set_char(index , char)
      if index >= byte_length
        #puts "Pass it on #{index} for #{self.object_id}:#{next_code.object_id}"
        return next_code.set_char( index - byte_length ,  char )
      end
      word_index = (index - 1) / 4 + 2
      old = get_internal_word( word_index )
      old = old && char << ((index-1)%4)
      set_internal_word(word_index , char)
    end
    def total_byte_length(start = 0 )
      start += byte_length
      return start unless self.next_code
      @next_code.total_byte_length(start)
    end
  end
end
