# to be precise, this should be an ObjectReference, as the Reference is a Value
# but we don't want to make that distinction all the time , so we don't.

# that does lead to the fact that we have Reference functions on the Object though

module Parfait
  class Object < Value

    def get_type()
      OBJECT_TYPE
    end

    # This is the crux of the object system. The class of an object is stored in the objects
    # memory (as opposed to an integer that has no memory and so always has the same class)
    #
    # In Salama we store the class in the Layout, and so the Layout is the only fixed
    # data that every object carries.
    def get_class()
      @layout.get_class()
    end

    # class stores the "latest" layout for instances, ir the layout a new object will
    # be created with.
    # inside parfait (and for now everywhere) these are constant.
    @@EMPTY =  { :names => [] , :types => []}
    def self.class_layout()
      @@EMPTY
    end

    def get_layout()
      @layout
    end

    def instance_variables
      @layout.instance_variables
    end

    def instance_variable_get name
      index = instance_variable_defined(name)
      return nil if index == nil
      return internal_get(index)
    end

    def instance_variable_set name , value
      index = instance_variable_defined(name)
      return nil if index == nil
      return internal_set(index , value)
    end

    def instance_variable_defined name
      @layout.index_of(name)
    end

    # Object
    # :nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :dup, :taint, :tainted?, :untaint,
    # :untrust, :untrusted?, :trust, :freeze, :frozen?, :to_s, :inspect, :methods, :singleton_methods, :protected_methods,
    # :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?,
    # :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?,
    # :extend, :display, :method, :public_method, :singleton_method, :define_singleton_method,
    # :object_id, :to_enum, :enum_for
    #
    # BasicObject
    # :==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__
  end
end
