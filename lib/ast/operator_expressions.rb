module Ast
  
  # assignment, like operators are really function calls
  
  class FuncallExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name , args
    end
    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }
      fun = Vm::FunctionCall.new( name ,  params )
      fun.load_args into
      fun.do_call into
      fun
    end
    
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        args.collect{|m| m.inspect }.join( ",") +"] )"  
    end
    def to_s
      "#{name}(" + args.join(",") + ")"
    end
    def attributes
      [:name , :args]
    end
  end
  
  class OperatorExpression < Expression
    attr_reader  :operator, :left, :right

    def initialize operator, left, right
      @operator, @left, @right = operator, left, right
    end
    def attributes
      [:operator, :left, :right]
    end
    def inspect
      self.class.name + ".new(" + operator.inspect + ", " +  left.inspect + "," + right.inspect + ")"  
    end
    def to_s
      "#{left} #{operator} #{right}"
    end
    def compile context , into
      r_val = right.compile(context , into)
      
      if operator == "="    # assignemnt
        raise "Can only assign variables, not #{left}" unless left.is_a?(NameExpression) 
        context.locals[left.name] = r_val
        return r_val
      end
      l_val = left.compile(context , into)

      case operator
      when ">"
        code = l_val.less_or_equal r_val
      when "+"
        code = l_val.plus r_val
      else
        raise "unimplemented operator #{operator} #{self}"
      end
    end
  end
end