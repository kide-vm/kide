require_relative "object"

module Virtual
  # static description of a method
  # name
  # args (with defaults)
  # code
  # return arg (usually mystery, but for coded ones can be more specific)
  # known local variable names
  # temp variables (numbered)
  #
  class MethodDefinition < Virtual::Object
    #return the main function (the top level) into which code is compiled
    def MethodDefinition.main
      MethodDefinition.new(:main , [] , Virtual::SelfReference )
    end
    def attributes
      [:name , :args , :receiver , :return_type , :start]
    end
    def initialize name , args , receiver = Virtual::SelfReference.new , return_type = Virtual::Mystery , start = MethodEnter.new(MethodReturn.new)
      @name = name.to_sym
      @args = args
      @locals = []
      @tmps = []
      @receiver = receiver
      @return_type = return_type
      @start = start
      @current = @start
    end
    attr_reader :name , :args , :receiver , :start
    attr_accessor :return_type , :current

    # add an instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add instruction
      raise instruction.inspect unless instruction.is_a? Instruction
      @current.insert(instruction) #insert after current
      @current = instruction
    end

    # determine whether this method has a variable by the given name
    # variables are locals and and arguments
    # used to determine if a send must be issued 
    def has_var name
      name = name.to_sym
      var = @args.find {|a| a.name == name }
      var = @locals.find {|a| a.name == name } unless var
      var = @tmps.find {|a| a.name == name } unless var
      var
    end

    # determine whether this method has an argument by the name
    def has_arg name
      name = name.to_sym
      var = @args.find {|a| a.name == name }
      var
    end

    def set_var name , var
      v = has_var name
      if( v )
        puts "resetting local #{v.inspect}"
      else
        v = Local.new(name , var)
        @locals << v
      end
      v
    end

    def get_var name
      var = has_var name
      raise "no var #{name} in method #{self.name} , #{@locals} #{@args}" unless var
      var
    end

    def get_tmp
      name = "__tmp__#{@tmps.length}"
      @tmps << name
      Ast::NameExpression.new(name)
    end
  end
end
