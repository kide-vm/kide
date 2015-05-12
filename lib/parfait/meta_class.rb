module Virtual

  # TODO : rethink - possibly needs to be a module to be mixed into Object
  #
  # class that acts like a class, but is really the object

  # described in the ruby language book as the eigenclass, what you get with
  # class MyClass
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just
  #     ....                              the class object but gives us the ability to use the
  #                                       syntax as if it were a class
  #                     PS: can't say i fancy the << self syntax and am considerernig adding a
  #                         keyword for it, like meta
  #                      In effect it is a very similar construct to   def self.function(...)
  #                      So one could write               def meta.function(...) and thus define on the meta-class
  class MetaClass < Object
    # no name, nor nothing. as this is just the object really

    def initialize(object)
      super()
      @functions = []
      @me_self = object
    end

    # in a non-booting version this should map to _add_singleton_method
    def add_function function
      raise "not a function #{function}" unless function.is_a? Virtual::Function
      raise "syserr " unless function.name.is_a? Symbol
      @functions << function
    end

    def get_function name
      name = name.to_sym
      f = @functions.detect{ |f| f.name == name }
      return f if f
      if( @me_self == :Object )
        puts "no function for :#{name} in Meta #{@me_self.inspect}"
        return nil
      else  #recurse up class hierachy unless we're at Object
        return @me_self.context.object_space.get_or_create_class(@me_self.super_class).get_function name
      end
    end

    # get the function and if not found, try superclasses. raise error if not found
    def resolve_method name
      fun = get_function name
      # TODO THE BOOK says is class A derives from B , then the metaclass of A derives from the metaclass of B
      # just get to it ! (and stop whimpering)
      raise "Method not found #{name} , for #{inspect}" unless fun
      fun
    end

    def to_s
      "#{inspect} on #{@me_self}, #{@functions.length} functions"
    end
  end
end
