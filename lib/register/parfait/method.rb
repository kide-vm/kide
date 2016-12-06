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

  # ps, the compiler injects its own info, see Register::MethodSource


  class Method < Object

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
