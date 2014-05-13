module Vm

  # name and args , return

  class CallSite < Value

    def initialize(name , args , function )
      @name = name
      @args = args
      @function = function
    end
    attr_reader  :function , :args , :name
    
    def load_args into
      args.each_with_index do |arg , index|
        puts "load " + arg.inspect
        arg.load( into , index )
      end
    end

    def do_call into
      into.add_code CMachine.instance.function_call into , self
    end
  end
end
