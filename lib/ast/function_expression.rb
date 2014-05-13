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
    
    def to_s
      "def #{name}( " + params.join(",") + ") \n" + block.join("\n") + "end\n"
    end
    def compile context , into 
      raise "function does not compile into anything #{self}" if into
      args = []
      locals = {}
      params.each_with_index do |param , index|
        arg = param.name
        arg_value = Vm::Integer.new(index)
        locals[arg] = arg_value
        args << arg_value
      end
      function = Vm::Function.new(name , args )
      parent_locals = context.locals
      parent_function = context.function
      context.locals = locals
      context.function = function

      context.program.add_function function
      into = function.entry
      block.each do |b|
        compiled = b.compile(context , into)
        if compiled.is_a? Vm::Block
          into = compiled
          he.breaks.loose
        else
          function.body.add_code compiled
        end
        puts compiled.inspect
      end
      context.locals = parent_locals
      context.function = parent_function
      function
    end

  end
end