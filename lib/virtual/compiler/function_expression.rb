module Virtual
  module Compiler
#    function attr_reader  :name, :params, :body , :receiver
    def self.compile_function  expression, method
      args = expression.params.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.is_a? Ast::NameExpression
        p.name
      end
      if expression.receiver
        #Do something clever instead of
        r = Compiler.compile(expression.receiver, method )
        if( r.is_a? Parfait::Class )
          class_name = r.name
        else
          raise "unimplemented #{r}"
        end
      else
        r = Self.new()
        class_name = method.for_class.name
      end
      new_method = MethodSource.create_method(class_name, expression.name , args )
      new_method.source.receiver = r
      new_method.for_class.add_instance_method new_method

      #frame = frame.new_frame
      return_type = nil
      expression.body.each do |ex|
        return_type = Compiler.compile(ex,new_method  )
        raise return_type.inspect if return_type.is_a? Instruction
      end
      new_method.source.return_type = return_type
      new_method
    end
    def scratch
      args = []
      locals = {}
      expression.params.each_with_index do |param , index|
        arg = param.name
        register = Register::RegisterReference.new(RegisterMachine.instance.receiver_register).next_reg_use(index + 1)
        arg_value = Integer.new(register)
        locals[arg] = arg_value
        args << arg_value
      end
      # class depends on receiver
      me = Integer.new( RegisterMachine.instance.receiver_register )
      if expression.receiver.nil?
        clazz = context.current_class
      else
        c = context.object_space.get_class_by_name expression.receiver.name.to_sym
        clazz = c.meta_class
      end

      function = Function.new(name , me , args )
      clazz.add_code_function function

      parent_locals = context.locals
      parent_function = context.function
      context.locals = locals
      context.function = function

      last_compiled = nil
      expression.body.each do |b|
        puts "compiling in function #{b}"
        last_compiled = b.compile(context)
        raise "alarm #{last_compiled} \n #{b}" unless last_compiled.is_a? Word
      end

      return_reg = Integer.new(RegisterMachine.instance.return_register)
      if last_compiled.is_a?(IntegerConstant) or last_compiled.is_a?(ObjectConstant)
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
