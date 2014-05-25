module Ast
    
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
      puts "compile operator #{to_s}"
      r_val = right.compile(context , into)
      puts "compiled right #{r_val.inspect}"
      if operator == "="    # assignment, value based
        raise "Can only assign variables, not #{left}" unless left.is_a?(NameExpression) 
        l_val = context.locals[left.name]
        if( l_val ) #variable existed, move data there
          l_val = l_val.move( into , r_val) 
        else
          l_val = context.function.new_local.move( into , r_val )
        end
        context.locals[left.name] = l_val
        return l_val
      end

      l_val = left.compile(context , into)
      into = into.scope binding
      
      case operator
      when ">"
        code = l_val.greater_than into , r_val
      when "<"
        code = l_val.less_than into , r_val
      when "=="
        code = l_val.equals into , r_val
      when "+"
        res = context.function.new_local
        into.res = l_val + r_val
        code = res
      when "-"
        res = context.function.new_local
        code = res.minus into , l_val , r_val
      else
        raise "unimplemented operator #{operator} #{self}"
      end
      code
    end
  end
end