# A TypedMethod is static object that primarily holds the executable code.
# It is called typed, because all arguments and variables it uses are typed.

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
# - frame:  A type object describing the local variables that the method has
# - for_type:  The Type the Method is for


module Parfait

  class TypedMethod < Object

    attr_reader :name , :instructions , :for_type ,:arguments , :frame , :binary

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
      @frame = Parfait.object_space.get_class_by_name( :NamedList ).instance_type
    end

    def set_instructions(inst)
      @instructions = inst
    end

    # determine whether this method has an argument by the name
    def has_argument( name )
      raise "has_argument #{name}.#{name.class}" unless name.is_a? Symbol
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
    def arguments_type( index )
      arguments.types.get(index + 1)
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local( name )
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      index = frame.variable_index( name )
      index ? (index - 1) : index
    end

    def add_local( name , type )
      index = has_local name
      return index if index
      @frame = @frame.add_instance_variable(name,type)
    end

    def frame_length
      frame.instance_length - 1
    end

    def locals_name( index )
      frame.names.get(index + 1)
    end

    def frame_type( index )
      frame.types.get(index + 1)
    end

    def sof_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@for_type.object_class.name}:#{name}(#{arguments.inspect})"
    end

  end
end
