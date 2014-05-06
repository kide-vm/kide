module Vm

  # name and args , return

  class FunctionCall < Block

    def initialize(name , args)
      super(name)
      @args = args
      @function = nil
    end
    attr_reader  :function , :args
    
    def assign_function context
      @function = context.program.get_function @name
      if @function
        raise "error #{self}" unless @function.arity != args.length
      else
        @function = context.program.get_or_create_function @name
      end
    end
    def load_args
      args.each_with_index do |arg , index|
        add_code arg.load(index)
      end
    end

    def do_call
      add_code Machine.instance.function_call self
    end
  end
end
