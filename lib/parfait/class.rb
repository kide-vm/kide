# Class is mainly a list of methods with a name (for now)
# layout of object is seperated into Layout

# A class describes the capabilities of a group of objects, ie what data it has
# and functions it responds to.
#
# The class also keeps a list of class methods (with names+code)
# Class methods are instance methods on the class object

# So it is essential that the class (the object defining the class)
# can carry methods. It does so as instance variables.
# In fact this property is implemented in the Object, as methods
# may be added to any object at run-time

# An Object carries the data for the instance variables it has
# The Layout lists the names of the instance variables
# The class keeps a list of instance methods, these have a name and code

require_relative "meta_class"

module Parfait
  class Class < Object
    attributes [:object_layout , :name , :instance_methods , :super_class , :meta_class]

    def initialize name , superclass
      super()
      self.name = name
      self.instance_methods = List.new
      self.super_class = superclass
      self.meta_class = nil#MetaClass.new(self)
      # the layout for this class (class = object of type Class) carries the class
      # as an instance. The relation is from an object through the Layout to it's class
      self.object_layout = Layout.new(self)
    end

    def allocate_object
      #space, and ruby allocate
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

    def method_names
      names = List.new
      self.instance_methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method method
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? Method
      raise "syserr #{method.name.class}" unless method.name.is_a? Symbol
      found = get_instance_method( method.name )
      if found
        self.instance_methods.delete(found)
        #raise "existed in #{self.name} #{Sof.write found.source.blocks}"
      end
      self.instance_methods.push method
      #puts "#{self.name} add #{method.name}"
      method
    end

    def remove_instance_method method_name
      found = get_instance_method( method_name )
      if found
        self.instance_methods.delete(found)
      else
        raise "No such method #{method_name} in #{self.name}"
      end
      self.instance_methods.delete found
    end

    def create_instance_method  method_name , arguments
      raise "create_instance_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      clazz = object_layout().object_class()
      raise "??? #{method_name}" unless clazz
      #puts "Self: #{self.class} clazz: #{clazz.name}"
      Method.new( clazz , method_name , arguments )
    end

    # this needs to be done during booting as we can't have all the classes and superclassses
    # instantiated. By that logic it should maybe be part of vm rather.
    # On the other hand vague plans to load the hierachy from sof exist, so for now...
    def set_super_class sup
      self.super_class = sup
    end

    def get_instance_method fname
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      self.instance_methods.each do |m|
        return m if(m.name == fname )
      end
      nil
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( self.super_class )
        method = self.super_class.resolve_method(m_name)
        raise "Method not found #{m_name}, for \n#{self}" unless method
      end
      method
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
