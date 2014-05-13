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
      args.each_with_index do |arg , index|
        puts "load " + arg.inspect
        into.add_code arg.move("r#{index}".to_sym)
      end
    end

    def do_call into
      into.add_code Machine.instance.function_call self
    end
  end
end
