# From a programmers perspective an object has hash like data (with instance variables as keys)
# and functions to work on that data.
# Only the object may access it's data directly.

# From an implementation perspective it is a chunk of memory with a type as the first
# word (instance of class Type).

# Objects are arranged or layed out (in memory) according to their Type
# every object has a Type. Type objects are immutable and may be reused for a group/class
# of objects.
# The Type of an object may change, but then a new Type is created
# The Type also defines the class of the object
# The Type is **always** the first entry (index 0) in an object

module Parfait
  TYPE_INDEX  = 0

  class Object
    attr :type

    def self.memory_size
      8
    end
    def self.type_length
      1
    end

    def self.new( *args )
      object = self.allocate

      # have to grab the class, because we are in the ruby class not the parfait one
      cl = Parfait.object_space.get_class_by_name( self.name.split("::").last.to_sym)

      # and have to set the type before we let the object do anything. otherwise boom
      object.set_type cl.instance_type
      object.send :initialize , *args
      object
    end

    def == other
      self.object_id == other.object_id
    end

    # This is the core of the object system.
    # The class of an object is stored in the objects memory
    #
    # In RubyX we store the class in the Type, and so the Type is the only fixed
    # data that every object carries.
    def get_class()
      l = get_type()
      #puts "Type #{l.class} in #{self.class} , #{self}"
      l.object_class()
    end

    # private
    def set_type(typ)
      raise "not type #{typ.class} in #{object_id.to_s(16)}" unless typ.is_a?(Type)
      self.type = typ
    end

    # so we can keep the raise in get_type
    def has_type?
      ! type.nil?
    end

    def get_type()
      raise "No type #{self.object_id.to_s(16)}:#{self.class} " unless has_type?
      type
    end

    # return the metaclass
    def meta
      MetaClass.new self
    end

    def get_instance_variables
      type.names
    end

    def get_instance_variable( name )
      index = instance_variable_defined(name)
      #puts "getting #{name} at #{index}"
      return nil if index == nil
      return get_internal_word(index)
    end

    def set_instance_variable( name , value )
      index = instance_variable_defined(name)
      return nil if index == nil
      return set_internal_word(index , value)
    end

    def instance_variable_defined( name )
      type.variable_index(name)
    end

    def padded_length
      Padding.padded_words( type.instance_length )
    end

    # parfait versions are deliberately called different, so we "relay"
    # have to put the "" on the names for rfx to take them off again
    def instance_variables
      get_instance_variables.to_a.collect{ |n| "#{n}".to_sym }
    end

    # name comes in as a ruby var name
    def instance_variable_ged name
      var = get_instance_variable name.to_s[1 .. -1].to_sym
      #puts "getting #{name}  #{var}"
      var
    end

  end
end
