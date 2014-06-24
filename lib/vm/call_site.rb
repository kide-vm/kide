module Vm

  # name and args , return

  class CallSite < Value

    def initialize(name , value , args , function )
      @name = name
      @value = value    
      @args = args
      @function = function
      raise "oh #{name} " unless value
    end
    attr_reader  :function , :args , :name , :value

    def load_args into
      if value.is_a?(IntegerConstant) or value.is_a?(ObjectConstant)
        function.receiver.load into , value
      else
        raise "meta #{name} " if value.is_a? Boot::MetaClass
        function.receiver.move( into, value ) if value.register_symbol != function.receiver.register_symbol
      end
      raise "function call '#{args.inspect}' has #{args.length} arguments, but function has #{function.args.length}" if args.length != function.args.length
      args.each_with_index do |arg , index|
        if arg.is_a?(IntegerConstant) or arg.is_a?(StringConstant)
          function.args[index].load into , arg
        else
          function.args[index].move( into, arg ) if arg.register_symbol != function.args[index].register_symbol
        end
      end
    end

    def do_call into
      RegisterMachine.instance.function_call into , self
    end
  end
end
