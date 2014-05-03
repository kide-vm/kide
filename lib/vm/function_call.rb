module Vm

  # name and args , return

  class FunctionCall < Value

    def initialize(name , args)
      @name = name
      @args = args
      @function = nil
    end
    attr_reader :name , :args , :function
    
    def compile context
      @function = context.program.get_function @name
      if @function
        raise "error #{self}" unless function.arity != @args.length
      else
        @function = context.program.get_or_create_function @name
      end
      args.each_with_index do |arg , index|
        arg.load
        arg.compile context
      end
      #puts "funcall #{self.inspect}"
      self.call
    end
    
    def call
      Machine.instance.function_call self
    end
  end
end
