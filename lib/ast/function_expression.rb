module Ast
  class FunctionExpression < Expression
    attr_reader  :name, :params, :block
    def initialize name, params, block
      @name, @params, @block = name, params, block
    end
    def == other
      compare other , [:name, :params, :block]
    end
    
    def compile context
      args = params.collect{|p| Vm::Value.type p.name }
      function = Vm::Function.new(name ,args )
      parent_locals = context.locals
      context.locals = {}
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