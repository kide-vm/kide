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

    # compiling a variable resolves it. if it wasn't defined, raise an exception 
    def compile frame
      # either a variable or needs to be called.
      frame.get(name)
#      frame.send name
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