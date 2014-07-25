module Ast
  class FunctionExpression < Expression
#    attr_reader  :name, :params, :body , :receiver
    def compile method , message
      args = params.collect do |p|
        raise "error, arguemnt must be a identifier, not #{p}" unless p.is_a? NameExpression
        Virtual::Argument.new( p.name , Virtual::Mystery.new )
      end
      r = receiver ? receiver.compile(method,message) : Virtual::SelfReference.new
      method = Virtual::MethodDefinition.new(name , args , r )
      #frame = frame.new_frame
      return_type = nil
      body.each do |ex|
        return_type = ex.compile(method,message )
        raise return_type.inspect if return_type.is_a? Virtual::Instruction
      end
      method.return_type = return_type
      method
    end
    def scratch
      args = []
      locals = {}
      params.each_with_index do |param , index|
        arg = param.name
        register = Virtual::RegisterReference.new(Virtual::RegisterMachine.instance.receiver_register).next_reg_use(index + 1)
        arg_value = Virtual::Integer.new(register)
        locals[arg] = arg_value
        args << arg_value
      end
      # class depends on receiver
      me = Virtual::Integer.new( Virtual::RegisterMachine.instance.receiver_register )
      if receiver.nil? 
        clazz = context.current_class
      else
        c = context.object_space.get_or_create_class receiver.name.to_sym
        clazz = c.meta_class
      end

      function = Virtual::Function.new(name , me , args )
      clazz.add_function function 

      parent_locals = context.locals
      parent_function = context.function
      context.locals = locals
      context.function = function

      last_compiled = nil
      body.each do |b|
        puts "compiling in function #{b}"
        last_compiled = b.compile(context)
        raise "alarm #{last_compiled} \n #{b}" unless last_compiled.is_a? Virtual::Word
      end
      
      return_reg = Virtual::Integer.new(Virtual::RegisterMachine.instance.return_register)
      if last_compiled.is_a?(Virtual::IntegerConstant) or last_compiled.is_a?(Virtual::ObjectConstant)
        return_reg.load function , last_compiled if last_compiled.register_symbol != return_reg.register_symbol
      else
        return_reg.move( function, last_compiled ) if last_compiled.register_symbol != return_reg.register_symbol
      end
      function.set_return return_reg
      
      context.locals = parent_locals
      context.function = parent_function
      function
    end
  end
end