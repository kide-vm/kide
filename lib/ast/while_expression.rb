module Ast
  class WhileExpression < Expression
#    attr_reader  :condition, :body
    def compile context
      into = context.function
      while_block = into.new_block "while"
      ret = while_block.new_block "return"
      into.insert_at while_block
      puts "compiling while condition #{condition}"
      cond_val = condition.compile(context)
      while_block.b ret , condition_code: cond_val.not_operator
      while_block.branch = ret

      last = nil

      body.each do |part|
        puts "compiling in while #{part}"
        last = part.compile(context)
      end
      while_block.b while_block
      puts "compile while end"
      into.insert_at ret
      return last
    end
  end

  
end