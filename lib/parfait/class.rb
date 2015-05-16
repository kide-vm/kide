
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

    def initialize name , super_class_name = :Object
      super()
      # class methods
      @instance_methods = []
      @name = name.to_sym
      @super_class_name = super_class_name.to_sym
      @meta_class = Virtual::MetaClass.new(self)
    end
    attr_reader :name , :instance_methods , :meta_class , :context , :super_class_name
    def add_instance_method method
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? Virtual::CompiledMethod
      raise "syserr " unless method.name.is_a? Symbol
      @instance_methods << method
    end

    def get_instance_method fname
      fname = fname.to_sym
      @instance_methods.detect{ |fun| fun.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      method = get_instance_method(m_name)
      unless method
        unless( @name == :Object)
          supr = Space.space.get_class_by_name(@super_class_name)
          method = supr.resolve_method(m_name)
        end
      end
      raise "Method not found #{m_name}, for #{@name}" unless method
      method
    end

    @@CLAZZ = { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
    def layout
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
