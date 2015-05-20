# A Method (at runtime , sis in Parfait) is static object that primarily holds the executable
# code.

# For reflection also holds arguments and such

#

module Parfait

  # static description of a method
  # name
  # arg_names
  # known local variable names
  # temp variables (numbered)
  # executable code

  # ps, the compiler injects its own info, see virtual::compiled_method_info


  class Method < Object

    def initialize name , arg_names
      @name = name
      @arg_names = arg_names
      @locals = []
      @tmps = []
    end
    attr_reader :name , :arg_names
    attr_accessor :for_class


    # determine whether this method has a variable by the given name
    # variables are locals and and arguments
    # used to determine if a send must be issued
    # return index of the name into the message if so
    def has_var name
      raise "uups #{name}.#{name.class}" unless name.is_a? Word
      index = has_arg(name)
      return index if index
      has_local(name)
    end

    # determine whether this method has an argument by the name
    def has_arg name
      raise "uups #{name}.#{name.class}" unless name.is_a? Word
      @arg_names.index_of name
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local name
      raise "uups #{name}.#{name.class}" unless name.is_a? Word
      index = @locals.index(name)
      index = @tmps.index(name) unless index
      index
    end

    def ensure_local name
      index = has_local name
      return index if index
      @locals << name
      @locals.length
    end

    def get_var name
      var = has_var name
      raise "no var #{name} in method #{self.name} , #{@locals} #{@arg_names}" unless var
      var
    end

  end
end
