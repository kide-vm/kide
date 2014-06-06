module Ast
  class FunctionExpression < Expression
#    attr_reader  :name, :params, :body , :receiver
    def compile context , into 
      raise "function does not compile into anything #{self}" if into
      args = []
      locals = {}
      params.each_with_index do |param , index|
        arg = param.name
        arg_value = Vm::Integer.new(index+2)
        locals[arg] = arg_value
        args << arg_value
      end
      # class depends on receiver
      if receiver.nil? 
        clazz = context.current_class
        me = Vm::Integer.new( Vm::Function::RECEIVER_REG )
      else
        c = context.object_space.get_or_create_class receiver.name.to_sym
        clazz = c.meta_class
        raise "get the constant loaded to 1"
      end

      function = Vm::Function.new(name , me , args )
      clazz.add_function function 

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