# A Method (at runtime , sis in Parfait) is static object that primarily holds the executable
# code.

# For reflection also holds arguments and such

#

module Parfait

  # static description of a method
  # name
  # arguments
  # known local variable names
  # executable code

  # ps, the compiler injects its own info, see Virtual::MethodSource


  class Method < Object

    def initialize clazz , name , arguments
      super()
      raise "No class #{name}" unless clazz
      self.for_class = clazz
      self.name = name
      self.code = BinaryCode.new name
      raise "Wrong type, expect List not #{arguments.class}" unless arguments.is_a? List
      arguments.each do |var|
        raise "Must be variable argument, not #{var}" unless var.is_a? Variable
      end
      self.arguments = arguments
      self.locals = List.new
    end
    attributes [:name , :arguments , :for_class , :code , :locals ]


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
      self.arguments.index_of name
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
      raise "no var #{name} in method #{self.name} , #{self.locals} #{self.arguments}" unless var
      var
    end

    def sof_reference_name
      self.name
    end

  end
end
