module Vm
  
  class Expression
    # evey Expression has a eval function that returns a value
    def eval 
      raise "abstract"
    end
  end

  class IntegerExpression < Expression
    attr_reader :value
    def initialize val
      @value = val
    end
    def eval(context, builder)
      builder.mov "r0" , value
    end
  end

  class NameExpression < Expression
    attr_reader  :name
    def initialize name
      @name = name
    end
    def eval(context, builder)
      param_names = context[:params] || []
      position    = param_names.index(name)
      raise "Unknown parameter #{name}" unless position

      builder.iload position
    end
  end

  class FuncallExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name , args
    end
    def eval(context, builder)
      args.each { |a| a.eval(context, builder) }
      types = [builder.int] * (args.length + 1)
      builder.invokestatic builder.class_builder, name, types
    end
  end

  class ConditionalExpression < Expression
    attr_reader  :cond, :if_true, :if_false
    def initialize cond, if_true, if_false
      @cond, @if_true, @if_false = cond, if_true, if_false
    end
    def eval(context, builder)
      cond.eval context, builder

      builder.ifeq :else

      if_true.eval context, builder
      builder.goto :endif

      builder.label :else
      if_false.eval context, builder

      builder.label :endif
    end
  end

  class FunctionExpression < Expression
    attr_reader  :name, :params, :block
    def initialize name, params, block
      @name, @params, @block = name, params, block
    end
    def eval(context, builder)
      param_names = [params].flatten.map(&:name)
      context[:params] = param_names
      types = [builder.int] * (param_names.count + 1)

      builder.public_static_method(self.name, [], *types) do |method|
        self.block.eval(context, method)
        method.ireturn
      end
    end
  end
end
