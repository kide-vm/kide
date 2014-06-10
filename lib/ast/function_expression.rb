module Ast
  class FunctionExpression < Expression
#    attr_reader  :name, :params, :body , :receiver
    def compile context , into 
      raise "function does not compile into anything #{self}" if into
      args = []
      locals = {}
      params.each_with_index do |param , index|
        arg = param.name
        register = Vm::RegisterUse.new(Vm::RegisterMachine.instance.receiver_register).next_reg_use(index + 1)
        arg_value = Vm::Integer.new(register)
        locals[arg] = arg_value
        args << arg_value
      end
      # class depends on receiver
      me = Vm::Integer.new( Vm::RegisterMachine.instance.receiver_register )
      if receiver.nil? 
        clazz = context.current_class
      else
        c = context.object_space.get_or_create_class receiver.name.to_sym
        clazz = c.meta_class
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
      
      return_reg = Vm::Integer.new(Vm::RegisterMachine.instance.return_register)
      if last_compiled.is_a?(Vm::IntegerConstant) or last_compiled.is_a?(Vm::ObjectConstant)
        return_reg.load into , last_compiled if last_compiled.register_symbol != return_reg.register_symbol
      else
        return_reg.move( into, last_compiled ) if last_compiled.register_symbol != return_reg.register_symbol
      end
      function.set_return return_reg
      
      context.locals = parent_locals
      context.function = parent_function
      function
    end
  end
end