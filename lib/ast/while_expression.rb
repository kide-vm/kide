module Ast
  class WhileExpression < Expression
#    attr_reader  :condition, :body
    def compile context
      into = context.function
      ret = into.new_block "while_end"
      while_block = into.new_block "while_start"
      into.insert_at while_block
      
      puts "compiling while condition #{condition}"
      cond_val = condition.compile(context)
      into.b ret , condition_code: cond_val.not_operator
      into.insertion_point.branch = ret

      last = nil

      body.each do |part|
        puts "compiling in while #{part}"
        last = part.compile(context)
      end
      into.b while_block
      into.insertion_point.branch = while_block
      
      puts "compile while end"
      into.insert_at ret
      return last
    end
  end

  
end