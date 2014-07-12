module Virtual
  # static description of a method
  # name
  # args (with defaults)
  # code
  # return arg (usually mystery, but for coded ones can be more specific)
  # known local variable names
  # temp variables (numbered)
  #
  class Method
    #return the main function (the top level) into which code is compiled
    def Method.main
      Method.new(:main)
    end
    def initialize name , args = [] , receiver = Virtual::Reference  , return_type = Virtual::Reference 
      @name = name
      @args = args
      @locals = []
      @receiver = receiver
      @return_type = return_type
      @start = MethodEnter.new
      @current = @start
    end
    attr_reader :name

    def add instruction
      @current.next = instruction
      @current = instruction
    end

    # determine whether this method has a variable by the given name
    # variables are locals and and arguments
    # used to determine if a send must be issued 
    def has_var name
      var = @args.find {|a| a == name }
      var = @locals.find {|a| a == name } unless var
      var
    end
  end
end
