# Class is mainly a list of methods with a name (for now)
# The memory layout of object is seperated into Layout

# A class describes the capabilities of a group of objects, ie what data it has
# and functions it responds to.
#

# So it is essential that the class (the object defining the class)
# can carry methods. It does so as instance variables.
# In fact this property is implemented in the Layout, as methods
# may be added to any object at run-time

# An Object carries the data for the instance variables it has
# The Layout lists the names of the instance variables
# The class keeps a list of instance methods, these have a name and code

module Parfait
  class Class < Object
    include Behaviour
    attributes [:object_layout , :name , :super_class_name]

    def initialize name , superclass
      super()
      self.name = name
      self.super_class_name = superclass
      # the layout for this class (class = object of type Class) carries the class
      # as an instance. The relation is from an object through the Layout to it's class
      # TODO the object layout should copy the stuff from superclass
      self.object_layout = Layout.new(self)
    end

    def allocate_object
      #space, and ruby allocate
    end

    def meta
      get_layout
    end

    def add_instance_name name
      self.object_layout.push name
    end

    def sof_reference_name
      name
    end

    def inspect
      "Class(#{name})"
    end


    def create_instance_method  method_name , arguments
      raise "create_instance_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      clazz = object_layout().object_class()
      raise "??? #{method_name}" unless clazz
      #puts "Self: #{self.class} clazz: #{clazz.name}"
      add_instance_method Method.new( clazz , method_name , arguments )
    end

    # this needs to be done during booting as we can't have all the classes and superclassses
    # instantiated. By that logic it should maybe be part of vm rather.
    # On the other hand vague plans to load the hierachy from sof exist, so for now...
    def set_super_class_name sup
      self.super_class_name = sup
    end

    def super_class
      Parfait::Space.object_space.get_class_by_name(self.super_class_name)
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
