module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
#    attr_reader  :name, :args , :receiver

    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }

      if receiver.is_a?(NameExpression) and (receiver.name == :self)
        function = context.current_class.get_or_create_function(name)
        value_receiver = Vm::Integer.new(Vm::Function::RECEIVER_REG)
      else
        value_receiver = receiver.compile(context , into)
        function = context.current_class.get_or_create_function(name)
      end
      # this lot below should go, since the compile should handle all
      if receiver.is_a? VariableExpression
        raise "not implemented instance var:#{receiver}"
      end
      raise "No such method error #{3.to_s}:#{name}" if (function.nil?)
      raise "No receiver error #{inspect}:#{value_receiver}:#{name}" if (value_receiver.nil?)
      call = Vm::CallSite.new( name ,  value_receiver , params  , function)
      current_function = context.function
      current_function.save_locals(context , into) if current_function
      call.load_args into
      call.do_call into
      current_function.restore_locals(context , into) if current_function
      puts "compile call #{function.return_type}"
      function.return_type
    end
  end
  
  class VariableExpression < CallSiteExpression
#      super( :_get_instance_variable  , [StringExpression.new(name)] )
  end
  
end