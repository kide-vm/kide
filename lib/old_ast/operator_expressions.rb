module Ast
  class OperatorExpression < Expression
#    attr_reader  :operator, :left, :right
    def compile context
      into = context.function
      puts "compiling operator #{to_s}"
      r_val = right.compile(context)
      #puts "compiled right #{r_val.inspect}"
      if operator == "="    # assignment, value based
        if(left.is_a? VariableExpression)
          left.make_setter
          l_val = left.compile(context)
        elsif left.is_a?(NameExpression)
          puts context.inspect unless context.locals
          l_val = context.locals[left.name]
          if( l_val ) #variable existed, move data there
            l_val = l_val.move( into , r_val) 
          else
            l_val = context.function.new_local.move( into , r_val )
          end
          context.locals[left.name] = l_val
        else
          raise "Can only assign variables, not #{left}" 
        end
        return l_val
      end
      
      l_val = left.compile(context)
      case operator
      when ">"
        code = l_val.greater_than into , r_val
      when "<"
        code = l_val.less_than into , r_val
      when ">="
        code = l_val.greater_or_equal into , r_val
      when "<="
        code = l_val.less_or_equal into , r_val
      when "=="
        code = l_val.equals into , r_val
      when "+"
        res = context.function.new_local
        into.add res , l_val , r_val
        code = res
      when "-"
        res = context.function.new_local
        code = res.minus into , l_val , r_val
      when "<<"
        res = context.function.new_local
        code = res.left_shift into , l_val , r_val
      else
        raise "unimplemented operator #{operator} #{self}"
      end
      code
    end
  end
end