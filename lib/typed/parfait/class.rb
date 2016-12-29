# Class is mainly a list of methods with a name. The methods are untyped.

# The memory layout of an object is determined by the Type (see there).
# The class carries the "current" type, ie the type an object would be if you created an instance
# of the class. Note that this changes over time and so many types share the same class.

# For dynamic OO it is essential that the class (the object defining the class)
# can carry methods. It does so as instance variables.
# In fact this property is implemented in the Type, as methods
# may be added to any object at run-time.

# An Object carries the data for the instance variables it has.
# The Type lists the names of the instance variables
# The Class keeps a list of instance methods, these have a name and code

module Parfait
  class Class < Object
    include Behaviour
    def self.attributes
      [:instance_type , :name , :super_class_name , :instance_names , :instance_methods]
    end

    attr_reader :instance_type , :name , :instance_methods , :super_class_name

    def initialize( name , superclass , instance_type)
      super()
      @name = name
      @super_class_name = superclass
      @instance_type = instance_type
    end

    def sof_reference_name
      name
    end

    def inspect
      "Class(#{name})"
    end

    # setting the type generates all methods for this type
    # (or will do, once we storet the methods code to do that)
    def set_instance_type( type )
      @instance_type = type
    end

    def super_class
      raise "No super_class for class #{@name}" unless @super_class_name
      s = Parfait::Space.object_space.get_class_by_name(@super_class_name)
      raise "superclass not found for class #{@name} (#{@super_class_name})" unless s
      s
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
