require_relative "kernel"

module Vm
  class Context
    def initialize 
      @locals = {}
    end
    def get name
      @locals[name]
    end
  end
end

# ast classes
module Parser
  Expression.class_eval do
    def compile builder , context
      raise "abstract #{self.inspect}"
    end
  end

  IntegerExpression.class_eval do
  end

  NameExpression.class_eval do
  end

  StringExpression.class_eval do
    def compile builder , context
      return string
    end
  end

  FuncallExpression.class_eval do
    def compile builder , context
      arguments = args.collect{|arg| arg.compile(builder , context) }
      function = context.get(name)
      unless function
        function = Vm::Kernel.send(name)
        context.add_function( name , function )
      end
      
    end    
  end

  ConditionalExpression.class_eval do
  end

  AssignmentExpression.class_eval do
  end
  FunctionExpression.class_eval do
  end
end
