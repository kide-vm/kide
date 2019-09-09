# Class is mainly a list of methods with a name.
# The methods are untyped, sis VoolMethod.

# The memory layout of an object is determined by the Type (see there).
# The class carries the "current" type, ie the type an object would be if you
# created an instance of the class.
# Note that this changes over time and so many types share the same class.

# For dynamic OO it is essential that the class (the object defining the class)
# can carry methods. It does so in an instance variable methods.

# An Object carries the data for the instance variables it has.
# The Type lists the names of the instance variables
# The Class keeps a list of instance methods, these have a name and (vool) code
# Each type in turn has a list of CallableMethods that hold binary code

module Parfait
  class Class < Object
    include Behaviour

    attr_reader :instance_type , :name , :instance_methods
    attr_reader :super_class_name , :meta_class

    def self.type_length
      6
    end
    def self.memory_size
      8
    end

    def initialize( name , superclass , instance_type)
      super()
      @name = name
      @super_class_name = superclass
      @instance_methods = List.new
      set_instance_type( instance_type )
      @meta_class = MetaClass.new( self )
    end

    def rxf_reference_name
      name
    end

    def inspect
      "Class(#{name})"
    end

    def add_method_for(name , type , frame , body )
      method = Parfait::VoolMethod.new(name , type , frame , body )
      add_method( method )
      method
    end

    def add_method(method)
      raise "Must be untyped method #{method}" unless method.is_a? Parfait::VoolMethod
      instance_methods.push(method)
    end

    def get_method(name)
      instance_methods.find{|m| m.name == name }
    end

    # adding an instance changes the instance_type to include that variable
    def add_instance_variable( name , type)
      @instance_type = instance_type.add_instance_variable( name , type )
    end

    # setting the type generates all methods for this type
    # (or will do, once we store the methods code to do that)
    def set_instance_type( type )
      raise "type must be type #{type}" unless type.is_a?(Type)
      @instance_type = type
    end

    # return the super class, but raise exception if either the super class name
    # or the super classs is nil.
    # Use only for non Object base class
    def super_class!
      raise "No super_class for class #{name}" unless super_class_name
      s = super_class
      raise "superclass not found for class #{name} (#{super_class_name})" unless s
      s
    end

    # return the super class
    # we only store the name, and so have to resolve.
    # Nil name means no superclass, and so nil is a valid return value
    def super_class
      return nil unless super_class_name
      Parfait.object_space.get_class_by_name(super_class_name)
    end

    # ruby 2.1 list (just for reference, keep at bottom)
    #:allocate, :new, :superclass

    # + modules
    # :<, :<=, :>, :>=, :included_modules, :include?, :name, :ancestors, :instance_methods, :public_instance_methods,
    # :protected_instance_methods, :private_instance_methods, :constants, :const_get, :const_set, :const_defined?,
    # :const_missing, :class_variables, :remove_class_variable, :class_variable_get, :class_variable_set,
    # :class_variable_defined?, :public_constant, :private_constant, :singleton_class?, :include, :prepend,
    # :module_exec, :class_exec, :module_eval, :class_eval, :method_defined?, :public_method_defined?,
    # :private_method_defined?, :protected_method_defined?, :public_class_method, :private_class_method, :autoload,
    # :autoload?, :instance_method, :public_instance_method

  end
end
