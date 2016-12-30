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
# - for_type:  The Type the Method is for


module Parfait

  class TypedMethod < Object

    def self.attributes
      [:name , :source , :instructions , :binary ,:arguments , :for_type, :locals ]
    end

    attr_reader :name , :instructions , :for_type ,:arguments , :locals , :binary

    # not part of the parfait model, hence ruby accessor
    attr_accessor :source

    def initialize( type , name , arguments )
      super()
      raise "No class #{name}" unless type
      raise "For type, not class #{type}" unless type.is_a?(Type)
      raise "Wrong argument type, expect Type not #{arguments.class}" unless arguments.is_a? Type
      @for_type = type
      @name = name
      @binary = BinaryCode.new 0
      @arguments = arguments
      @locals = Parfait.object_space.get_class_by_name( :NamedList ).instance_type 
    end

    def set_instructions(inst)
      @instructions = inst
    end

    # determine whether this method has an argument by the name
    def has_arg( name )
      raise "has_arg #{name}.#{name.class}" unless name.is_a? Symbol
      index = arguments.variable_index( name )
      index ? (index - 1) : index
    end

    def add_argument(name , type)
      @arguments = @arguments.add_instance_variable(name,type)
    end

    def arguments_length
      arguments.instance_length - 1
    end

    def argument_name( index )
      arguments.names.get(index + 1)
    end
    def argument_type( index )
      arguments.types.get(index + 1)
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
      @locals = @locals.add_instance_variable(name,type)
    end

    def locals_length
      locals.instance_length - 1
    end

    def locals_name( index )
      locals.names.get(index + 1)
    end

    def locals_type( index )
      locals.types.get(index + 1)
    end

    def sof_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@for_type.object_class.name}:#{name}(#{arguments.inspect})"
    end

  end
end
