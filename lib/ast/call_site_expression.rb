module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name.to_sym , args
    end
    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }
      function = context.current_class.get_or_create_function(name)
      raise "Forward declaration not implemented (#{name}) #{inspect}" if function == nil
      call = Vm::CallSite.new( name ,  params  , function)
      current_function = context.function
      current_function.save_locals(context , into) if current_function
      call.load_args into
      call.do_call into
      current_function.restore_locals(context , into) if current_function
      puts "compile call #{function.return_type}"
      function.return_type
    end

    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        args.collect{|m| m.inspect }.join( ",") +"] )"  
    end
    def to_s
      "#{name}(" + args.join(",") + ")"
    end
    def attributes
      [:name , :args]
    end
  end
  
end