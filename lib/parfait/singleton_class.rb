#
# In many respects a SingletonClass is like a Class. We haven't gone to the full ruby/oo level
# yet, where the singleton_class is actually a class instance, but someday.

# A Class in general can be viewed as a way to generate methods for a group of objects.

# A SingletonClass serves the same function, but just for one object, the class object that it
# is the singleton_class of.
# This is slightly different in the way that the type of the class must actually
# change, whereas for a class the instance type changes and only objects generated
# henceafter have a different type.

# Another current difference is that a singleton_class has no superclass. Also no name.
# There is a one to one relationship between a class instance and it's singleton_class instance.

module Parfait
  class SingletonClass < Behaviour

    attr_reader :clazz

    def self.type_length
      4
    end
    def self.memory_size
      8
    end

    def initialize( clazz )
      clazz_hash = clazz.type.to_hash
      @clazz = clazz
      super( Type.for_hash(clazz_hash , self , 1) )
      @clazz.set_type( @instance_type )
    end

    def rxf_reference_name
      @clazz.name
    end

    def name
      :"#{clazz.name}.Single"
    end

    def inspect
      "SingletonClass(#{@clazz.name})"
    end

    def to_s
      inspect
    end

    # adding an instance changes the instance_type to include that variable
    def add_instance_variable( name , type)
      super(name,type)
      @clazz.set_type(@instance_type)
    end

    # the super class of a singleton classs is  the singleton class of the super class.
    # In effect the single classes shadow the class tree, leading to the fact that
    # a class method defined in a super_class is accessible to a derived class in
    # much the same way as normal methods are accessible in (normal) derived classes.
    def super_class
      @clazz.super_class.single_class if @clazz.super_class
    end

    # return the name of the superclass (see there)
    def super_class_name
      super_class.name if @clazz.super_class
    end

  end
end
