# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module FakeMem
  def initialize
    @memory = [0,nil]
  end
end

module Parfait
  # Objects memory functions. Object memory is 1 based
  # but we implement it with ruby array (0 based) and use 0 as type-word
  # These are the same functions that Builtin implements at run-time
  class Object
    include FakeMem
    def self.new_object *args
#      Space.space.get_class_by_name(:Word)
      #puts "I am #{self}"
      object = self.new(*args)
      object
    end
    # these internal functions are _really_ internal
    # they respresent the smallest code needed to build larger functionality
    # but should _never_ be used outside parfait. in fact that should be impossible
    def internal_object_get_typeword
      @memory[0]
    end
    def internal_object_set_typeword w
      @memory[0] = w
    end
    def internal_object_length
      @memory.length - 1  # take of type-word
    end
    # 1 -based index
    def internal_object_get(index)
      @memory[index]
    end
    # 1 -based index
    def internal_object_set(index , value)
      @memory[index] = value
    end
    def internal_object_grow(length)
      old_length = internal_object_length()
      while( old_length < length )
        internal_object_set( old_length + 1, nil)
        old_length = old_length + 1
      end
    end
  end
  class Parfait::Class
  end
  class Parfait::List
  end

  # Functions to generate parfait objects
  def self.new_word( string )
    string = string.to_s if string.is_a? Symbol
    word = Parfait::Word.new( string.length )
    string.codepoints.each_with_index do |code , index |
      word.set_char(index + 1 , code)
    end
    word
  end
  def self.new_list array
    list = List.new_object
    list.set_length array.length
    index = 1
    while index < array.length do
      list.set(index , array[index - 1])
    end
    list
  end

  Word.class_eval do
    def to_s
      string = ""
      index = 1
      while( index <= self.length)
        string[index - 1] = get_char(index).chr
        index = index + 1
      end
      string
    end
  end
end
