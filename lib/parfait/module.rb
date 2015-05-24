
# A module describes the capabilities of a group of objects, ie what data it has
# and functions it responds to.
# The group may be a Class, but a module may be included into classes and objects too.
#
# The class also keeps a list of class methods (with names+code)
# Class methods are instance methods on the class object

# So it is essential that the class (the object defining the class)
# can carry methods. It does so as instance variables.
# In fact this property is implemented in the Object, as methods
# may be added to any object at run-time

module Parfait
  class Module < Object
    def initialize name , superclass
      @name = name
      @instance_methods = []
      @name = name
      @super_class = superclass
      @meta_class = Virtual::MetaClass.new(self)
    end

    def name
      @name
    end

    def instance_methods
      @instance_methods
    end
    def add_instance_method method
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? Method
      raise "syserr #{method.name.class}" unless method.name.is_a? Word
      method.for_class = self
      @instance_methods << method
      method
    end

    def create_instance_method name , arg_names
      add_instance_method Method.new( name , arg_names )
    end

    # this needs to be done during booting as we can't have all the classes and superclassses
    # instantiated. By that logic it should maybe be part of vm rather.
    # On the other hand vague plans to load the hierachy from sof exist, so for now...
    def set_super_class sup
      @super_class = sup
    end

    def get_instance_method fname
      raise "uups #{fname}.#{fname.class}" unless fname.is_a? Word
      @instance_methods.detect{ |fun| fun.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      raise "uups #{m_name}.#{m_name.class}" unless m_name.is_a? Word
      method = get_instance_method(m_name)
      unless method
        unless( @name == "Object" )
          method = @super_class.resolve_method(m_name)
        end
      end
      raise "Method not found #{m_name}, for #{@name}" unless method
      method
    end


    # :<, :<=, :>, :>=, :included_modules, :include?, :name, :ancestors, :instance_methods, :public_instance_methods,
    # :protected_instance_methods, :private_instance_methods, :constants, :const_get, :const_set, :const_defined?,
    # :const_missing, :class_variables, :remove_class_variable, :class_variable_get, :class_variable_set,
    # :class_variable_defined?, :public_constant, :private_constant, :singleton_class?, :include, :prepend,
    # :module_exec, :class_exec, :module_eval, :class_eval, :method_defined?, :public_method_defined?,
    # :private_method_defined?, :protected_method_defined?, :public_class_method, :private_class_method, :autoload,
    # :autoload?, :instance_method, :public_instance_method
  end
end
