module Vm

  # name and args , return

  class FunctionCall < Block

    def initialize(name , args)
      super(name)
      @name = name
      @values = args
      @function = nil
    end
    attr_reader  :function
    def args
      values
    end
    
    def compile context
      @function = context.program.get_function @name
      if @function
        raise "error #{self}" unless @function.arity != @values.length
      else
        @function = context.program.get_or_create_function @name
      end
      args.each_with_index do |arg |
        arg.compile context
      end
      args.each_with_index do |arg , index|
        arg.load index
      end
      #puts "funcall #{self.inspect}"
      self.do_call
    end
    
    def do_call
      Machine.instance.function_call self
    end
  end
end
