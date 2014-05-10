module Ast
  class FunctionExpression < Expression
    attr_reader  :name, :params, :block
    def initialize name, params, block
      @name, @params, @block = name.to_sym, params, block
    end
    def attributes
      [:name, :params, :block]
    end
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        params.collect{|m| m.inspect }.join( ",") +"] , [" + 
        block.collect{|m| m.inspect }.join( ",") +"] )"  
    end
    
    def compile context
      parent_locals = context.locals
      context.locals = {}
      args = []
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