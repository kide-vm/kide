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

    attr_reader :name , :risc_instructions , :for_type , :cpu_instructions
    attr_reader :arguments_type , :frame_type , :binary , :next_method

    # not part of the parfait model, hence ruby accessor
    attr_accessor :source

    def initialize( type , name , arguments_type , frame_type)
      super()
      raise "No class #{name}" unless type
      raise "For type, not class #{type}" unless type.is_a?(Type)
      @for_type = type
      @name = name
      init(arguments_type, frame_type)
    end

    # (re) init with given args and frame types
    # also set first risc_instruction to a label
    def init(arguments_type, frame_type)
      raise "Wrong argument type, expect Type not #{arguments_type.class}" unless arguments_type.is_a? Type
      raise "Wrong frame type, expect Type not #{frame_type.class}" unless frame_type.is_a? Type
      @arguments_type = arguments_type
      @frame_type = frame_type
      @binary = BinaryCode.new(0)
      name = "#{@for_type.name}.#{@name}"
      @risc_instructions = Risc.label(self, name)
      @risc_instructions << Risc.label( self, "unreachable")
    end

    def translate_cpu(translator)
      @cpu_instructions = @risc_instructions.to_cpu(translator)
      nekst = @risc_instructions.next
      while(nekst)
        cpu = nekst.to_cpu(translator) # returning nil means no replace
        @cpu_instructions << cpu if cpu
        nekst = nekst.next
      end
      total = @cpu_instructions.total_byte_length / 4 + 1
      @binary.extend_to( total )
      @cpu_instructions
    end

    # determine whether this method has an argument by the name
    def has_argument( name )
      raise "has_argument #{name}.#{name.class}" unless name.is_a? Symbol
      index = arguments_type.variable_index( name )
      index ? (index - 1) : index
    end

    def add_argument(name , type)
      @arguments_type = @arguments_type.add_instance_variable(name,type)
    end

    def arguments_length
      arguments_type.instance_length - 1
    end

    def argument_name( index )
      arguments_type.names.get(index + 1)
    end
    def argument_type( index )
      arguments_type.types.get(index + 1)
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local( name )
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      index = frame_type.variable_index( name )
      index ? (index - 1) : index
    end

    def add_local( name , type )
      index = has_local name
      return index if index
      @frame_type = @frame_type.add_instance_variable(name,type)
    end

    def frame_length
      frame_type.instance_length - 1
    end

    def locals_name( index )
      frame_type.names.get(index + 1)
    end

    def locals_type( index )
      frame_type.types.get(index + 1)
    end

    def sof_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@for_type.object_class.name}:#{name}(#{arguments_type.inspect})"
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
