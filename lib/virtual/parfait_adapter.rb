# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module FakeMem
  def initialize
    super()
    @memory = [0,nil]
    @position = nil
    @length = -1
    if Parfait::Space.object_space and Parfait::Space.object_space.objects
      Parfait::Space.object_space.add_object self
    else
      # Note: the else is handled in boot, by ading the space "by hand", as it slips though
      # puts "Got away #{self.class}"
    end
    if Virtual::Machine.instance.class_mappings
      init_layout
    else
      #puts "No init for #{self.class}:#{self.object_id}"
    end
  end
  def init_layout
    vm_name = self.class.name.split("::").last
    clazz = Virtual::Machine.instance.class_mappings[vm_name]
    raise "Class not found #{vm_name}" unless clazz
    raise "Layout not set #{vm_name}" unless clazz.object_layout
    self.set_layout clazz.object_layout
  end
  #TODO, this is copied from module Positioned, maybe avoid duplication ?
  def position
    if @position == nil
      raise "position accessed but not set at #{mem_length} for #{self.inspect[0...1000]}"
    end
    @position
  end
  def set_position pos
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    if @position != nil and ((@position - pos).abs > 32)
      raise "position set again #{pos}!=#{@position} for #{self.class}"
    end
    @position = pos
  end
  # objects only come in lengths of multiple of 8 words
  # but there is a constant overhead of 2 words, one for type, one for layout
  # and as we would have to subtract 1 to make it work without overhead, we now have to add 7
  def padded len
    a = 32 * (1 + (len + 7)/32 )
    #puts "#{a} for #{len}"
    a
  end

  def padded_words words
    padded(words*4) # 4 == word length, a constant waiting for a home
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
    def internal_object_shrink(length)
      old_length = internal_object_length()
      while( length < old_length  )
        @memory.delete_at(old_length)
        old_length = old_length - 1
      end
    end

    def to_s
      Sof::Writer.write(self)
    end
    def inspect
      to_s
    end
  end
  class List
    def mem_length
      padded_words(get_length())
    end
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
    def mem_length
      padded(1 + length())
    end

    def == other
      return false unless other.is_a?(String) or other.is_a?(Word)
      as_string = self.to_s
      unless other.is_a? String
        other = other.to_s
      end
      as_string == other
    end

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
    word = Parfait::Word.new_object( string.length )
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
