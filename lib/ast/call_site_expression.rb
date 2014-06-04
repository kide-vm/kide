module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
#    attr_reader  :name, :args , :receiver

    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }

      if receiver.name == :self
        function = context.current_class.get_or_create_function(name)
      elsif receiver.is_a? ModuleName
        c_name = receiver.name
        clazz = context.object_space.get_or_create_class c_name
        raise "uups #{clazz}.#{c_name}" unless clazz
        #class qualifier, means call from metaclass
        clazz = clazz.meta_class
        function = clazz.get_or_create_function(name)
      elsif receiver.is_a? VariableExpression
        raise "not implemented instance var:#{receiver}"
      else
        raise "not implemented case (dare i say system error):#{receiver}"
      end
      raise "No such method error #{clazz.to_s}:#{name}" if function == nil
      call = Vm::CallSite.new( name ,  params  , function)
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