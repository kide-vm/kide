module Vm
  # class that acts like a class, but is really the object
  
  # described in the ruby language book as the eigenclass, what you get with 
  # class MyClass 
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just the class object
  #     ....                                           but gives us the ability to use the syntax as if it were a class
  #                     PS: can't say i fancy the << self syntax and am considerernig adding a keyword for it, like meta
  #                      In effect it is a very similar construct to   def self.function(...)
  #                      So one could write               def meta.function(...) and thus define on the meta-class
  class MetaClass < Code
    # no name, nor nothing. as this is just the object really
    
    def initialize(object)
      super()
      @functions = []
      @me_self = object
    end
    
    # in a non-booting version this should map to _add_singleton_method
    def add_function function
      raise "not a function #{function}" unless function.is_a? Function
      raise "syserr " unless function.name.is_a? Symbol
      @functions << function
    end

    def get_function name
      name = name.to_sym
      @functions.detect{ |f| f.name == name }
    end
        
  end
end
