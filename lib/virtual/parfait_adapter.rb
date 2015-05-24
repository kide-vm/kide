# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module FakeMem
  def initialize
    @memory = [0,nil]
    if Parfait::Space.object_space and Parfait::Space.object_space.objects
      Parfait::Space.object_space.add_object self
    else
      #TODO, must go through spce instance variables "by hand"
      puts "fixme, no layout for #{self.class.name}"
    end
    init_layout if Virtual::Machine.instance.class_mappings
  end
  def init_layout
    vm_name = self.class.name.split("::").last
    clazz = Virtual::Machine.instance.class_mappings[vm_name]
    raise "Class not found #{vm_name}" unless clazz
    self.set_layout clazz.object_layout
  end
end

module Parfait
  # Objects memory functions. Object memory is 1 based
  # but we implement it with ruby array (0 based) and use 0 as type-word
  # These are the same functions that Builtin implements at run-time
  class Object
    include FakeMem
    # these internal functions are _really_ internal
    # they respresent the smallest code needed to build larger functionality
    # but should _never_ be used outside parfait. in fact that should be impossible
    def internal_object_get_typeword
      raise "failed init for #{self.class}" unless @memory
      @memory[0]
    end
    def internal_object_set_typeword w
      raise "failed init for #{self.class}" unless @memory
      @memory[0] = w
    end
    def internal_object_length
      raise "failed init for #{self.class}" unless @memory
      @memory.length - 1  # take of type-word
    end
    # 1 -based index
    def internal_object_get(index)
      @memory[index]
    end
    # 1 -based index
    def internal_object_set(index , value)
      raise "failed init for #{self.class}" unless @memory
      @memory[index] = value
    end
    def internal_object_grow(length)
      old_length = internal_object_length()
      while( old_length < length )
        internal_object_set( old_length + 1, nil)
        old_length = old_length + 1
      end
    end

    def to_s
      Sof::Writer.write(self)
    end

  end
  class List
    def to_sof_node(writer , level , ref )
      Sof.array_to_sof_node(self , writer , level , ref )
    end
    def to_a
      array = []
      index = 1
      while( index <= self.get_length)
        array[index - 1] = get(index)
        index = index + 1
      end
      array
    end
  end
  class Dictionary
    def to_sof_node(writer , level , ref)
      Sof.hash_to_sof_node( self , writer , level , ref)
    end
  end

  class Method
    attr_accessor :info
  end
  class Word
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

module Virtual
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
    list = Parfait::List.new_object
    list.set_length array.length
    index = 1
    while index <= array.length do
      list.set(index , array[index - 1])
      index = index + 1
    end
    list
  end
end
