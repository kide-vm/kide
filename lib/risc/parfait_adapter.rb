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

    # 0 -based index
    def set_internal_word(index , value)
      return super if index < self.class.type_length
      raise "Word[#{index}] = nil" if( value.nil? and self.class != List)
      @memory[index] = value
      value
    end
  end

  # new list from ruby array to be precise
  def self.new_list array
    list = Parfait::List.new
    list.set_length array.length
    index = 0
    while index < array.length do
      list.set(index , array[index])
      index = index + 1
    end
    list
  end

  # Word from string
  def self.new_word( string )
    string = string.to_s if string.is_a? Symbol
    word = Word.new( string.length )
    string.codepoints.each_with_index do |code , index |
      word.set_char(index , code)
    end
    word
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
