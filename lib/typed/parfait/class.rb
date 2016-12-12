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
    attributes [:instance_type , :name , :super_class_name]

    def initialize name , superclass
      super()
      self.name = name
      self.super_class_name = superclass
      # the type for this class (class = object of type Class) carries the class
      # as an instance. The relation is from an object through the Type to it's class
      # TODO the object type should copy the stuff from superclass
      self.instance_type = Type.new(self)
    end

    def allocate_object
      #space, and ruby allocate
    end

    def add_instance_name name
      self.instance_type.push name
    end

    def sof_reference_name
      name
    end

    def inspect
      "Class(#{name})"
    end

    def create_instance_method  method_name , arguments
      raise "create_instance_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      clazz = instance_type().object_class()
      raise "??? #{method_name}" unless clazz
      #puts "Self: #{self.class} clazz: #{clazz.name}"
      add_instance_method TypedMethod.new( clazz , method_name , arguments )
    end

    # this needs to be done during booting as we can't have all the classes and superclassses
    # instantiated. By that logic it should maybe be part of vm rather.
    # On the other hand vague plans to load the hierachy from sof exist, so for now...
    def set_super_class_name sup
      raise "super_class_name must be a name, not #{sup}" unless sup.is_a?(Symbol)
      self.super_class_name = sup
    end

    def super_class
      raise "No super_class for class #{self.name}" unless self.super_class_name
      s = Parfait::Space.object_space.get_class_by_name(self.super_class_name)
      raise "superclass not found for class #{self.name} (#{self.super_class_name})" unless s
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
