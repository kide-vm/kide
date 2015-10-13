
# Class derives from and derives most of it's functionality (that you would associate with a class)
# from there
# class is mainly a list of methods with a name (for now)
# layout of object is seperated into Layout

# A Class is a module that can be instantiated

# An Object carries the data for the instance variables it has
# The Layout lists the names of the instance variables
# The class keeps a list of instance methods, these have a name and code

require_relative "meta_class"

module Parfait
  class Class < Module
    attribute :object_layout

    def initialize name , super_class
      super( name , super_class)
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
    # ruby 2.1 list (just for reference, keep at bottom)
    #:allocate, :new, :superclass

  end
end
