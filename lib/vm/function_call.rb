module Vm

  # name and args , return

  class FunctionCall < Value

    def initialize(name , args)
      @name = name
      @args = args
      @function = nil
    end
    attr_reader  :function , :args , :name
    
    def load_args into
      raise args.inspect
      args.each_with_index do |arg , index|
        into.add_code arg.load("r#{index}".to_sym)
      end
    end

    def do_call into
      into.add_code Machine.instance.function_call self
    end
  end
end
