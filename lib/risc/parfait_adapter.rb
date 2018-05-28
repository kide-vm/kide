require_relative "fake_memory"

module Parfait
  class DataObject < Object

    def self.allocate
      r = super
      r.instance_variable_set(:@memory , Risc::FakeMemory.new(self.type_length , self.memory_size))
      r
    end

    # 0 -based index
    def get_internal_word(index)
      return super if index < self.class.type_length
      @memory[index]
    end

    # 1 -based index
    def set_internal_word(index , value)
      return super if index < self.class.type_length
      raise "Word[#{index}] = nil" if( value.nil? and self.class != List)
      @memory[index] = value
      value
    end
  end
end

class Symbol

  def has_type?
    true
  end
  def get_type
    l = Parfait.object_space.classes[:Word].instance_type
    #puts "LL #{l.class}"
    l
  end
  def padded_length
    Padding.padded( to_s.length + 4)
  end

end
