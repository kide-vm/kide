# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module Register
  def self.new_list array
    list = Parfait::List.new
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

  def has_layout?
    true
  end
  def get_layout
    l = Register.machine.space.classes[:Word].object_layout
    #puts "LL #{l.class}"
    l
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
      str += "Machine has object=#{Register.machine.objects.has_key?(self.object_id)} "
      raise str + " for Symbol:#{self}"
    end
    pos
  end
  def position= pos
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
    include Padding
    include Positioned

    def fake_init
      @memory = Array.new(16)
      @position = nil
      self # for chaining
    end

    # 1 -based index
    def internal_object_get(index)
      @memory[index]
    end
    # 1 -based index
    def internal_object_set(index , value)
      raise "failed init for #{self.class}" unless @memory
      @memory[index] = value
      value
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
    attr_accessor :source
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

  ## sof related stuff
  class Object
    # parfait versions are deliberately called different, so we "relay"
    # have to put the "@" on the names for sof to take them off again
    def instance_variables
      get_instance_variables.to_a.collect{ |n| "@#{n}".to_sym }
    end
    # name comes in as a ruby @var name
    def instance_variable_get name
      var = get_instance_variable name.to_s[1 .. -1].to_sym
      #puts "getting #{name}  #{var}"
      var
    end
  end

end
