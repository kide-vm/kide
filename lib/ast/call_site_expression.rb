module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name.to_sym , args
    end
    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }
      function = context.program.get_or_create_function(name)
      raise "Forward declaration not implemented (#{name}) #{inspect}" if function == nil
      call = Vm::CallSite.new( name ,  params  , function)
      save_locals context , into
      call.load_args into
      call.do_call into
      resore_locals context , into
    end

    def save_locals context , into
      into.instance_eval do 
        push [:r0, :r1 , :r2]
      end
    end

    def resore_locals context , into
      into.instance_eval do 
        pop [:r0, :r1 , :r2]
      end
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