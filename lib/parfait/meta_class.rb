module Parfait

  # class that acts like a class, but is really the object

  # described in the ruby language book as the eigenclass, what you get with
  # class MyClass
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just
  #     ....                              the class object but gives us the ability to use the
  #                                       syntax as if it were a class
  #

  class MetaClass < Object
    attribute :me

    def initialize(object)
      super()
      self.me = object
    end

    def super_class
      Space.object_space.get_class_by_name(self.me.super_class_name).meta
    end

    def name
      "Meta#{me.name}".to_sym
    end
    # in a non-booting version this should map to _add_singleton_method
    # def add_function function
    #   raise "not a function #{function}" unless function.is_a? Register::Function
    #   raise "syserr " unless function.name.is_a? Symbol
    #   self.functions << function
    # end

    # def get_function name
    #   name = name.to_sym
    #   f = self.functions.detect{ |f| f.name == name }
    #   return f if f
    #   if( self.me_self == "Object" )
    #     puts "no function for :#{name} in Meta #{self.me_self.inspect}"
    #     return nil
    #   else  #recurse up class hierachy unless we're at Object
    #     return self.me_self.context.object_space.get_class_by_name(self.me_self.super_class).get_function name
    #   end
    # end

    # get the function and if not found, try superclasses. raise error if not found
    # def resolve_method name
    #   fun = get_function name
    #   # TODO THE BOOK says is class A derives from B , then the metaclass of
    #   # A derives from the metaclass of B
    #   # just get to it ! (and stop whimpering)
    #   raise "Method not found #{name} , for #{inspect}" unless fun
    #   fun
    # end

    # def to_s
    #   "#{inspect} on #{self.me_self}, #{self.functions.length} functions"
    # end
  end
end
