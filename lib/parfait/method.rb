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

    def initialize clazz , name , arg_names
      super()
      raise "No class #{name}" unless clazz
      self.for_class = clazz
      self.name = name
      self.code = BinaryCode.new name
      raise "Wrong type, expect List not #{arg_names.class}" unless arg_names.is_a? List
      self.arg_names = arg_names
      self.locals = List.new
    end
    attributes [:name , :arg_names , :for_class , :code , :locals ]


    # determine whether this method has a variable by the given name
    # variables are locals and and arguments
    # used to determine if a send must be issued
    # return index of the name into the message if so
    def has_var name
      raise "has_var #{name}.#{name.class}" unless name.is_a? Symbol
      index = has_arg(name)
      return index if index
      has_local(name)
    end

    # determine whether this method has an argument by the name
    def has_arg name
      raise "has_arg #{name}.#{name.class}" unless name.is_a? Symbol
      self.arg_names.index_of name
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local name
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      index = self.locals.index_of(name)
      index
    end

    def ensure_local name
      index = has_local name
      return index if index
      self.locals.push name
      self.locals.get_length
    end

    def get_var name
      var = has_var name
      raise "no var #{name} in method #{self.name} , #{self.locals} #{self.arg_names}" unless var
      var
    end

    def sof_reference_name
      self.name
    end

  end
end
