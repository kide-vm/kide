# to be precise, this should be an ObjectReference, as the Reference is a Value
# but we don't want to make that distinction all the time , so we don't.

# that does lead to the fact that we have Reference functions on the Object though

# Objects are arranged or layed out (in memory) according to their Layout
# every object has a Layout. Layout objects are immutalbe and may be resued for a group/class
# off objects.
# The Layout of an object may change, but then a new Layout is created
# The Layout also defines the class of the object
# The Layout is **always** the first entry (index 1) in an object, but the type word is index 0

module Parfait
  class Object < Value

    TYPE_WORD     = 0
    LAYOUT_INDEX  = 1
    CLASS_INDEX   = 2  #only used in class, but keep constants together

    def self.new *args
      object = self.allocate
      object.send :initialize , *args
      #puts "NEW #{object.class}"
      object
    end

    def == other
      self.object_id == other.object_id
    end

    def get_type_of( index )
      type_word = internal_object_get( TYPE_WORD )
      res = type_word >> (index*4)
      # least significant nibble, this is still adhoc, not tested. but the idea is there
      res & 0xF
    end

    # This is the crux of the object system. The class of an object is stored in the objects
    # memory (as opposed to an integer that has no memory and so always has the same class)
    #
    # In Salama we store the class in the Layout, and so the Layout is the only fixed
    # data that every object carries.
    def get_class()
      l = get_layout()
      puts "Layout #{l.class} in #{self.class} , #{self}"
      l.get_object_class()
    end

    # private
    def set_layout(layout)
      # puts "Layout was set for #{self.class}"
      raise "Nil layout" unless layout
      internal_object_set(LAYOUT_INDEX , layout)
    end

    # so we can keep the raise in get_layout
    def has_layout?
      ! internal_object_get(LAYOUT_INDEX).nil?
    end

    def get_layout()
      l = internal_object_get(LAYOUT_INDEX)
      raise "No layout #{self.object_id.to_s(16)}:#{self.class} " unless l
      return l
    end

    def get_instance_variables
      get_layout().object_instance_names
    end

    def get_instance_variable name
      index = instance_variable_defined(name)
      return nil if index == nil
      return internal_object_get(index)
    end

    def set_instance_variable name , value
      index = instance_variable_defined(name)
      return nil if index == nil
      return internal_object_set(index , value)
    end

    def instance_variable_defined name
      get_layout().index_of(name)
    end

    def word_length
      padded_words( get_layout().get_length() )
    end

    # Object
    # :nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :dup, :taint, :tainted?, :untaint,
    # :untrust, :untrusted?, :trust, :freeze, :frozen?, :to_s, :inspect, :methods, :singleton_methods, :protected_methods,
    # :private_methods, :public_methods, :get_instance_variables, :get_instance_variable, :set_instance_variable, :instance_variable_defined?,
    # :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?,
    # :extend, :display, :method, :public_method, :singleton_method, :define_singleton_method,
    # :object_id, :to_enum, :enum_for
    #
    # BasicObject
    # :==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__
  end
end
