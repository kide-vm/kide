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
        if arg.is_a?(IntegerConstant) or arg.is_a?(StringConstant)
          function.args[index].load into , arg
        else
          function.args[index].move( into, arg ) if arg.register != args[index].register
        end
      end
    end

    def do_call into
      RegisterMachine.instance.function_call into , self
    end
  end
end
