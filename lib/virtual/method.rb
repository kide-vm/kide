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
  class Method < Virtual::Object
    #return the main function (the top level) into which code is compiled
    def Method.main
      Method.new(:main , [] , Virtual::SelfReference )
    end
    def attributes
      [:name , :args , :receiver , :return_type , :start]
    end
    def initialize name , args , receiver = Virtual::SelfReference.new , return_type = Virtual::Mystery , start = MethodEnter.new
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
    attr_accessor :return_type

    def add instruction
      raise instruction.inspect unless instruction.is_a? Instruction
      @current.next = instruction
      @current = instruction
    end

    # determine whether this method has a variable by the given name
    # variables are locals and and arguments
    # used to determine if a send must be issued 
    def has_var name
      var = @args.find {|a| a == name }
      var = @locals.find {|a| a == name } unless var
      var = @tmps.find {|a| a == name } unless var
      var
    end
    alias :get_var :has_var

    def get_tmp
      name = "__tmp__#{@tmps.length}"
      @tmps << name
      Ast::NameExpression.new(name)
    end
  end
end