module Ast
  class FunctionExpression < Expression
    attr_reader  :name, :params, :body
    def initialize name, params, body
      @name, @params, @body = name.to_sym, params, body
    end
    def attributes
      [:name, :params, :body]
    end
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        params.collect{|m| m.inspect }.join( ",") +"] , [" + 
        body.collect{|m| m.inspect }.join( ",") +"] )"  
    end
    
    def to_s
      "def #{name}( " + params.join(",") + ") \n" + body.join("\n") + "end\n"
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
      context.program.add_function function

      parent_locals = context.locals
      parent_function = context.function
      context.locals = locals
      context.function = function

      into = function.body
      body.each do |b|
        compiled = b.compile(context , into)
        function.return_type = compiled
        puts "compiled in function #{compiled.inspect}"
        raise "alarm #{compiled} \n #{b}" unless compiled.is_a? Vm::Word
      end
      context.locals = parent_locals
      context.function = parent_function
      function
    end

  end
end