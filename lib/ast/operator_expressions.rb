module Ast
  
  # assignment, like operators are really function calls
  
  class FuncallExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name , args
    end
  
    def compile context
      fun = Vm::FunctionCall.new( name , args.collect{ |a| a.compile(context) } )
      fun.assign_function context
      fun.load_args
      fun.do_call
      fun
    end
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        args.collect{|m| m.inspect }.join( ",") +"] )"  
    end
  
    def attributes
      [:name , :args]
    end
  end
  
  class AssignmentExpression < Expression
    attr_reader  :assignee, :assigned
    def initialize assignee, assigned
      @assignee, @assigned = assignee, assigned
    end
    def inspect
      self.class.name + ".new(" + assignee.inspect + ", " + assigned.inspect + ")"
    end
    
    def compile context
      value = @assigned.compile(context)
      variable = Vm::Variable.new @assignee , :r0 , value
      context.locals[@assignee] = variable
      variable
    end

    def attributes
      [:assignee, :assigned]
    end
  end
end