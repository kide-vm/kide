# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module FakeMem
  def initialize
    super()
    @memory = [0,nil]
    @position = nil
    if Virtual.machine.class_mappings
      init_layout
    else
      #puts "No init for #{self.class}:#{self.object_id}"
    end
  end
  def init_layout
    vm_name = self.class.name.split("::").last.to_sym
    clazz = Virtual.machine.class_mappings[vm_name]
    raise "Class not found #{vm_name}" unless clazz
    raise "Layout not set #{vm_name}" unless clazz.object_layout
    self.set_layout clazz.object_layout
  end
end
module Virtual
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
class Symbol
  include Positioned
  include Padding

  def init_layout;  end
  def has_layout?
    true
  end
  def get_layout
    Virtual.machine.class_mappings[:Word].object_layout
  end
  def word_length
    padded to_s.length
  end
  # not the prettiest addition to the game, but it wasn't me who decided symbols are frozen in 2.x
  def cache_positions
    unless defined?(@@symbol_positions)
      @@symbol_positions = {}
    end
    @@symbol_positions
  end
  def position
    pos = cache_positions[self]
    if pos == nil
      str = "position accessed but not set, "
      str += "Machine has object=#{Virtual.machine.objects.include?(self)} "
      raise str + " for Symbol:#{self}"
    end
    pos
  end
  def set_position pos
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    old = cache_positions[self]
    if old != nil and ((old - pos).abs > 32)
      raise "position set again #{pos}!=#{old} for #{self}"
    end
    cache_positions[self] = pos
  end

end

module Parfait
  # Objects memory functions. Object memory is 1 based
  # but we implement it with ruby array (0 based) and use 0 as type-word
  # These are the same functions that Builtin implements at run-time
  class Object
    include FakeMem
    include Padding
    include Positioned

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
      #shaddowing layout so we can ignore memory in Sof
      if(index == LAYOUT_INDEX)
        @layout = value
      end
      @memory[index] = value
    end
    def internal_object_grow(length)
      old_length = internal_object_length()
      while( old_length < length )
        internal_object_set( old_length + 1, nil)
        old_length = old_length + 1
      end
    end
    def internal_object_shrink(length)
      old_length = internal_object_length()
      while( length < old_length  )
        @memory.delete_at(old_length)
        old_length = old_length - 1
      end
    end

    def to_s
      Sof.write(self)
    end
    def inspect
      to_s
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
      index = 1
      while( index <= self.length)
        string[index - 1] = get_char(index).chr
        index = index + 1
      end
      string
    end
  end
end
