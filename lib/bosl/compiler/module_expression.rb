module Bosl
  module Compiler
#    module attr_reader  :name ,:expressions
    def self.compile_module expression , context
      return clazz
    end

    def self.compile_class expression , method
      clazz = Parfait::Space.object_space.get_class_by_name! expression.name
      #puts "Compiling class #{clazz.name.inspect}"
      expression_value = nil
      expression.expressions.each do |expr|
        # check if it's a function definition and add
        # if not, execute it, but that does means we should be in salama (executable), not ruby.
        #  ie throw an error for now
        raise "only functions for now #{expr.inspect}" unless expr.is_a? Ast::FunctionExpression
        #puts "compiling expression #{expression}"
        expression_value = Compiler.compile(expr,method  )
        #puts "compiled expression #{expression_value.inspect}"
      end

      return expression_value
    end
  end
end
