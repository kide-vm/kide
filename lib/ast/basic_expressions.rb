# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
#    attr_reader :value
    def compile frame
      Virtual::IntegerConstant.new value
    end
  end

  class TrueExpression
    def compile frame
      Virtual::TrueValue.new
    end
  end
  
  class FalseExpression
    def compile frame
      Virtual::FalseValue.new
    end
  end
  
  class NilExpression
    def compile frame
      Virtual::NilValue.new
    end
  end

  class NameExpression < Expression
#    attr_reader  :name

    # compiling name needs to check if it's a variable and if so resolve it
    # otherwise it's a method without args and a send is ussued.
    # this makes the namespace static, ie when eval and co are implemented method needs recompilation
    def compile frame , method
      if method.has_var(name)
        frame.compile_get(name , method )
      else
        frame.compile_send( name , method )
      end
    end
  end

  class ModuleName < NameExpression

    def compile context
      clazz = context.object_space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      #class qualifier, means call from metaclass
      clazz = clazz.meta_class
      puts "CLAZZ #{clazz}"
      clazz
    end    
  end

  class StringExpression < Expression
#    attr_reader  :string
    def compile context
      value = Virtual::StringConstant.new(string)
      context.object_space.add_object value 
      value
    end
  end
end