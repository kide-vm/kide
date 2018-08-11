require_relative "fake_memory"

module Parfait
  def self.variable_index(clazz_name , name)
    clazz = clazz_name.split("::").last.to_sym
    type = self.type_names[clazz]
    i = type.keys.index(name)
    raise "no #{name} for #{clazz}" unless i
    i + 1
  end
  class Object

    def self.allocate
      r = super
      r.instance_variable_set(:@memory , Risc::FakeMemory.new(r ,self.type_length , self.memory_size))
      r
    end

    # 0 -based index
    def get_internal_word(index)
      @memory[index]
    end

    # 0 -based index
    def set_internal_word(index , value)
      @memory[index] = value
      value
    end

    def self.attr( *attributes )
      attributes = [attributes] unless attributes.is_a?(Array)
      attributes.each do |name|
        define_getter(name)
        define_setter(name)
      end
    end

    def self.define_getter(name)
      define_method(name) do
        #puts "GETTING #{name} for #{self.class.name} in #{object_id.to_s(16)}"
        if(name == :type)
          return @memory[0]
        end
        index = Parfait.variable_index(self.class.name, name)
        get_internal_word(index)
      end
    end

    def self.define_setter(name)
      define_method("#{name}=".to_sym ) do |value|
        #puts "SETTING #{name}= for #{self.class.name} in #{object_id.to_s(16)}"
        if(name == :type)
          @memory[0] = value
          return value
        end
        index = Parfait.variable_index(self.class.name, name)
        set_internal_word(index , value)
      end
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
