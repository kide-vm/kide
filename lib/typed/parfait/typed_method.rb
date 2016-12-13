# A TypedMethod is static object that primarily holds the executable code.
# It is called typed, because all arguments and variables it uses are typed.
# (Type means basic type, ie integer or reference)

# It's relation to the method a ruby programmer knows (called RubyMethod) is many to one,
# meaning one RubyMethod (untyped) has many TypedMethod implementations.
# The RubyMethod only holds ruby code, no binary.

# The Typed method has the following instance variables
# - name : This is the same as the ruby method name it implements
# - source: is currently the ast (or string) that represents the "code". This is historic
#           and will change to the RubyMethod that it implements
# - instructions: The sequence of instructions the source (ast) was compiled to
#                 Instructions derive from class Instruction and form a linked list
# - binary:  The binary (jumpable) code that the instructions get assembled into
# - arguments: A type object describing the arguments (name+types) to be passed
# - locals:  A type object describing the local variables that the method has
# - for_class:  The class the Method is for (TODO, should be Type)


module Parfait

  class TypedMethod < Object

    attributes [:name , :source , :instructions , :binary ,:arguments , :for_class, :locals ]
    # not part of the parfait model, hence ruby accessor
    attr_accessor :source

    def initialize( clazz , name , arguments )
      super()
      raise "No class #{name}" unless clazz
      raise "Wrong argument type, expect Type not #{arguments.class}" unless arguments.is_a? Type
      self.for_class = clazz
      self.name = name
      self.binary = BinaryCode.new 0
      self.arguments = arguments
      self.locals = Type.new Space.object_space.get_class_by_name( :Object )

    end

    # determine whether this method has an argument by the name
    def has_arg( name )
      raise "has_arg #{name}.#{name.class}" unless name.is_a? Symbol
      index = arguments.variable_index( name )
      index ? (index - 1) : index
    end

    def add_argument(name , type)
      self.arguments = self.arguments.add_instance_variable(name,type)
    end

    def arguments_length
      arguments.instance_length - 1
    end

    def argument_name( index )
      arguments.get(index * 2 + 1)
    end
    def argument_type( index )
      arguments.get(index * 2 + 2)
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local( name )
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      index = locals.variable_index( name )
      index ? (index - 1) : index
    end

    def add_local( name , type )
      index = has_local name
      return index if index
      self.locals = self.locals.add_instance_variable(name,type)
    end

    def locals_length
      locals.instance_length - 1
    end

    def locals_name( index )
      locals.get(index * 2 + 1)
    end
    def locals_type( index )
      locals.get(index * 2 + 2)
    end

    def sof_reference_name
      "Method: " + self.name.to_s
    end

    def inspect
      "#{self.for_class.name}:#{name}(#{arguments.inspect})"
    end

  end
end
