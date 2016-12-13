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
# - arguments: A List of Variables that can/are passed
# - locals:  A List of Variables that the method has
# - for_class:  The class the Method is for (TODO, should be Type)


module Parfait

  class TypedMethod < Object

    attributes [:name , :source , :instructions , :binary ,:arguments , :for_class, :locals ]
    # not part of the parfait model, hence ruby accessor
    attr_accessor :source

    def initialize clazz , name , arguments
      super()
      raise "No class #{name}" unless clazz
      self.for_class = clazz
      self.name = name
      self.binary = BinaryCode.new 0
      raise "Wrong type, expect List not #{arguments.class}" unless arguments.is_a? List
      arguments.each do |var|
        raise "Must be variable argument, not #{var}" unless var.is_a? Variable
      end
      self.arguments = arguments
      self.locals = List.new
    end

    # determine whether this method has an argument by the name
    def has_arg name
      raise "has_arg #{name}.#{name.class}" unless name.is_a? Symbol
      max = self.arguments.get_length
      counter = 1
      while( counter <= max )
        if( self.arguments.get(counter).name == name)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local name
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      max = self.locals.get_length
      counter = 1
      while( counter <= max )
        if( self.locals.get(counter).name == name)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    def ensure_local name , type
      index = has_local name
      return index if index
      var = Variable.new( type , name)
      self.locals.push var
      self.locals.get_length
    end

    def sof_reference_name
      "Method: " + self.name.to_s
    end

    def inspect
      "#{self.for_class.name}:#{name}(#{arguments.inspect})"
    end

  end
end
