module Ast
  class ModuleExpression < Expression
#    attr_reader  :name ,:expressions
    def compile context
      clazz = context.object_space.get_or_create_class name
      puts "Created class #{clazz.name.inspect}"
      context.current_class = clazz
      expressions.each do |expression|
        # check if it's a function definition and add
        # if not, execute it, but that does means we should be in salama (executable), not ruby. ie throw an error for now
        raise "only functions for now #{expression.inspect}" unless expression.is_a? Ast::FunctionExpression
        puts "compiling expression #{expression}"
        expression_value = expression.compile(context )
        #puts "compiled expression #{expression_value.inspect}"
      end

      return clazz
    end
  end

  class ClassExpression < ModuleExpression
    def compile method , message
      clazz = ::Virtual::BootSpace.space.get_or_create_class name
      puts "Created class #{clazz.name.inspect}"
#      context.current_class = clazz
      expressions.each do |expression|
        # check if it's a function definition and add
        # if not, execute it, but that does means we should be in salama (executable), not ruby. ie throw an error for now
        raise "only functions for now #{expression.inspect}" unless expression.is_a? Ast::FunctionExpression
        #puts "compiling expression #{expression}"
        expression_value = expression.compile(method,message )
        clazz.add_instance_method(expression_value)
        #puts "compiled expression #{expression_value.inspect}"
      end

      return clazz
    end
  end
end