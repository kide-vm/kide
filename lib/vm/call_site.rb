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
        if arg.is_a? IntegerConstant
          Vm::Integer.new(index).load into , arg
        else
          raise "no #{arg.inspect}" if arg.register != index
          #arg.load( into , index )
        end
      end
    end

    def do_call into
      CMachine.instance.function_call into , self
    end
  end
end
