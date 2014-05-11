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
  
  class OperatorExpression < Expression
    attr_reader  :operator, :left, :right

    def initialize operator, left, right
      @operator, @left, @right = operator, left, right
    end
    def attributes
      [:operator, :left, :right]
    end
    def inspect
      self.class.name + ".new(" + operator.inspect + ", " +  left.inspect + "," + right.inspect + ")"  
    end
  
    def compile context
      parent_locals = context.locals
      context.locals = {}
      args = []

      #assignemnt
      value = @assigned.compile(context)
      variable = Vm::Variable.new @assignee , :r0 , value
      context.locals[@assignee] = variable
      variable


      params.each do |param|
        args << param.compile(context) # making the argument a local
      end
#      args = params.collect{|p| Vm::Value.type p.name }
      function = Vm::Function.new(name ,args )
      context.program.add_function function
      block.each do |b|
        compiled = b.compile context
        if compiled.is_a? Vm::Block
          he.breaks.loose
        else
          function.body.add_code compiled
        end
        puts compiled.inspect
      end
      context.locals = parent_locals if parent_locals
      function
    end
  end
end