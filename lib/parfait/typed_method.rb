# A TypedMethod is static object that primarily holds the executable code.
# It is called typed, because all arguments and variables it uses are "typed",
# that is to say the names are known and form a type (not that the types of the
# variables are known). The objects type is known too, which means all instances
# variable names are known (not their respective type).

# It's relation to the method a ruby programmer knows (called VoolMethod) is many to one,
# meaning one VoolMethod (untyped) has many TypedMethod implementations.
# The VoolMethod only holds vool code, no binary.

# The Typed method has the following instance variables
# - name : This is the same as the ruby method name it implements
# - binary:  The binary (jumpable) code that the instructions get assembled into
# - arguments_type: A type object describing the arguments (name+types) to be passed
# - frame_type:  A type object describing the local variables that the method has
# - for_type:  The Type the Method is for


module Parfait

  class TypedMethod < Object

    attr_reader :name , :for_type
    attr_reader :arguments_type , :frame_type , :binary , :next_method

    def initialize( type , name , arguments_type , frame_type)
      super()
      raise "No class #{name}" unless type
      raise "For type, not class #{type}" unless type.is_a?(Type)
      @for_type = type
      @name = name
      init(arguments_type, frame_type)
    end

    # (re) init with given args and frame types
    def init(arguments_type, frame_type)
      raise "Wrong argument type, expect Type not #{arguments_type.class}" unless arguments_type.is_a? Type
      raise "Wrong frame type, expect Type not #{frame_type.class}" unless frame_type.is_a? Type
      @arguments_type = arguments_type
      @frame_type = frame_type
      @binary = BinaryCode.new(0)
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local( name )
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      frame_type.variable_index( name )
    end

    def add_local( name , type )
      index = has_local( name )
      return index if index
      @frame_type = @frame_type.add_instance_variable(name,type)
    end

    def rxf_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@for_type.object_class.name}:#{name}(#{arguments_type.inspect})"
    end

    def each_binary( &block )
      bin = binary
      while(bin) do
        block.call( bin )
        bin = bin.next
      end
    end
    def each_method( &block )
      block.call( self )
      next_method.each_method( &block ) if next_method
    end
    def set_next( method )
      @next_method = method
    end
  end
end
