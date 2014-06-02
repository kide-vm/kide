module Ast
  class ModuleExpression < Expression
    attr_reader  :name ,:expressions
    def initialize name , expressions
      @name = name.to_sym
      @expressions = expressions
    end
    def inspect
      self.class.name + ".new(" + @name.inspect + " ," + @expressions.inspect + " )"  
    end
    def to_s
      "module #{name}\n #{expressions}\nend\n"
    end
    def attributes
      [:name , :expressions]
    end
    def compile context , into
      clazz = context.object_space.get_or_create_class name
      puts "Created class #{clazz.name.inspect}"
      context.current_class = clazz
      expressions.each do |expression|
        # check if it's a function definition and add
        # if not, execute it, but that does means we should be in crystal (executable), not ruby. ie throw an error for now
        raise "only functions for now #{expression.inspect}" unless expression.is_a? Ast::FunctionExpression
        puts "compiling expression #{expression}"
        expression_value = expression.compile(context , nil )
        #puts "compiled expression #{expression_value.inspect}"
      end

      return clazz
    end
  end

  class ClassExpression < ModuleExpression

  end
end