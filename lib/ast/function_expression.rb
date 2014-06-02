module Ast
  class FunctionExpression < Expression
    attr_reader  :name, :params, :body , :receiver
    def initialize name, params, body , receiver = nil
      @name = name.to_sym
      @params =  params
      @body = body
      @receiver = receiver
    end
    def attributes
      [:name, :params, :body , :receiver]
    end
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        params.collect{|m| m.inspect }.join( ",") +"] , [" + 
        body.collect{|m| m.inspect }.join( ",") +"] ,"+  receiver.inspect + " )"
    end
    
    def to_s
      ret = "def "
      ret += "#{receiver}." if receiver
      ret + "#{name}( " + params.join(",") + ") \n" + body.join("\n") + "end\n"
    end
    def compile context , into 
      raise "function does not compile into anything #{self}" if into
      args = []
      locals = {}
      params.each_with_index do |param , index|
        arg = param.name
        arg_value = Vm::Integer.new(index+1)
        locals[arg] = arg_value
        args << arg_value
      end
      class_name = context.current_class.name
      function = Vm::Function.new(name , args )
      # class depends on receiver
      context.current_class.add_function function 

      parent_locals = context.locals
      parent_function = context.function
      context.locals = locals
      context.function = function

      into = function.body
      last_compiled = nil
      body.each do |b|
        puts "compiling in function #{b}"
        last_compiled = b.compile(context , into)
        raise "alarm #{last_compiled} \n #{b}" unless last_compiled.is_a? Vm::Word
      end
      
      return_reg = Vm::Integer.new(7)
      if last_compiled.is_a?(Vm::IntegerConstant) or last_compiled.is_a?(Vm::StringConstant)
        return_reg.load into , last_compiled if last_compiled.register != return_reg.register
      else
        return_reg.move( into, last_compiled ) if last_compiled.register != return_reg.register
      end
      function.set_return return_reg
      
      context.locals = parent_locals
      context.function = parent_function
      function
    end

  end
end