
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

    def initialize name , super_class = nil
      super( name , super_class)
      # the layout for this class (class = object of type Class) carries the class
      # as an instance. The relation is from an object through the Layout to it's class
      @object_layout = Layout.new_object(self)
    end

    def object_layout
      @object_layout
    end

    def allocate_object
      #space, and ruby allocate
    end

    def add_instance_name name
      @object_layout.push name
    end

    @@CLAZZ = { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
    def old_layout
      @@CLAZZ
    end
    def mem_length
      padded_words(3)
    end
    def to_s
      inspect[0...300]
    end

    # ruby 2.1 list (just for reference, keep at bottom)
    #:allocate, :new, :superclass
  end
end
