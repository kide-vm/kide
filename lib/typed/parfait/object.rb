# From a programmers perspective an object has hash like data (with instance variables as keys)
# and functions to work on that data.
# Only the object may access it's data directly.

# From an implementation perspective it is a chunk of memory with a type as the first
# word (instance of class Type).

# Objects are arranged or layed out (in memory) according to their Type
# every object has a Type. Type objects are immutalbe and may be reused for a group/class
# off objects.
# The Type of an object may change, but then a new Type is created
# The Type also defines the class of the object
# The Type is **always** the first entry (index 1) in an object

module Parfait
  TYPE_INDEX  = 1

  class Object

    # we define new, so we can do memory layout also at compile time.
    # At compile time we fake memory by using a global array for pages
    def self.new *args
      object = self.allocate
      object.compile_time_init if object.respond_to?(:compile_time_init)

      # have to grab the class, because we are in the ruby class not the parfait one
      cl = Space.object_space.get_class_by_name( self.name.split("::").last.to_sym)

      # and have to set the type before we let the object do anything. otherwise boom
      object.set_type cl.instance_type

      object.send :initialize , *args
      object
    end

    include Padding
    include Positioned

    def compile_time_init
      @memory = Array.new(16)
      @position = nil
      self # for chaining
    end

    # 1 -based index
    def get_internal_word(index)
      @memory[index]
    end

    # 1 -based index
    def set_internal_word(index , value)
      raise "failed init for #{self.class}" unless @memory
      raise "Word[#{index}] = " if((self.class == Parfait::Word) and value.nil? )
      @memory[index] = value
      value
    end

    def self.attributes names
      names.each{|name| attribute(name) }
    end

    def self.attribute name
      define_method(name) { get_instance_variable(name) }
      define_method("#{name}=".to_sym) { |value| set_instance_variable(name , value) }
    end

    def == other
      self.object_id == other.object_id
    end

    # This is the crux of the object system. The class of an object is stored in the objects
    # memory (as opposed to an integer that has no memory and so always has the same class)
    #
    # In Salama we store the class in the Type, and so the Type is the only fixed
    # data that every object carries.
    def get_class()
      l = get_type()
      #puts "Type #{l.class} in #{self.class} , #{self}"
      l.object_class()
    end

    # private
    def set_type(type)
      # puts "Type was set for #{self.class}"
      raise "Nil type" unless type
      set_internal_word(TYPE_INDEX , type)
    end

    # so we can keep the raise in get_type
    def has_type?
      ! get_internal_word(TYPE_INDEX).nil?
    end

    def get_type()
      l = get_internal_word(TYPE_INDEX)
      #puts "get type for #{self.class} returns #{l.class}"
      raise "No type #{self.object_id.to_s(16)}:#{self.class} " unless l
      return l
    end

    # return the metaclass
    def meta
      MetaClass.new self
    end

    def get_instance_variables
      get_type().instance_names
    end

    def get_instance_variable name
      index = instance_variable_defined(name)
      #puts "getting #{name} at #{index}"
      return nil if index == nil
      return get_internal_word(index)
    end

    def set_instance_variable name , value
      index = instance_variable_defined(name)
      return nil if index == nil
      return set_internal_word(index , value)
    end

    def instance_variable_defined name
      get_type().variable_index(name)
    end

    def padded_length
      padded_words( get_type().instance_length )
    end

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
