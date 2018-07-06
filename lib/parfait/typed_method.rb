require_relative "callable"
# A TypedMethod is static object that primarily holds the executable code.
# It is called typed, because all arguments and variables it uses are "typed",
# that is to say the names are known and form a type (not that the types of the
# variables are known). The object's type is known too, which means all instances
# variable names are known (not their respective type).

# It's relation to the method a ruby programmer knows (called VoolMethod) is many to one,
# meaning one VoolMethod (untyped) has many TypedMethod implementations.
# The VoolMethod only holds vool code, no binary.

# The Typed method has the following instance variables
# - name : This is the same as the ruby method name it implements
# - binary:  The binary (jumpable) code that the instructions get assembled into
# - arguments_type: A type object describing the arguments (name+types) to be passed
# - frame_type:  A type object describing the local variables that the method has
# - self_type:  The Type the Method is for


module Parfait

  class TypedMethod < Callable

    attr_reader :name , :next_method

    def initialize( self_type , name , arguments_type , frame_type)
      @name = name
      super(self_type , arguments_type , frame_type)
    end

    def ==(other)
      return false unless other.is_a?(TypedMethod)
      return false if @name != other.name
      super
    end

    def rxf_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@self_type.object_class.name}:#{name}(#{arguments_type.inspect})"
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
