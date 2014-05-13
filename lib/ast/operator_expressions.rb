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
      puts "compile #{to_s}"
      r_val = right.compile(context , into)
      if operator == "="    # assignemnt
        raise "Can only assign variables, not #{left}" unless left.is_a?(NameExpression) 
        if r_val.is_a? Vm::IntegerConstant
          puts context.attributes.keys.join(" ")
          next_register = context.function.next_register
          r_val = Vm::Integer.new(next_register).load( into , r_val )
        end
        context.locals[left.name] = r_val
        return r_val
      end
      l_val = left.compile(context , into)

      case operator
      when ">"
        code = l_val.less_or_equal into , r_val
      when "+"
        code = l_val.plus into , r_val
      else
        raise "unimplemented operator #{operator} #{self}"
      end
    end
  end
end