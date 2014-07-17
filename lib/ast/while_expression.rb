module Ast
  class WhileExpression < Expression
#    attr_reader  :condition, :body
    def compile frame , method
      start = Virtual::Label.new("while_start")
      method.add start
      is = condition.compile(frame , method)
      branch = Virtual::ImplicitBranch.new "while"
      merge = Virtual::Label.new(branch.name)
      branch.other = merge   #false jumps to end of while
      method.add branch
      last = is
      body.each do |part|
        last = part.compile(frame,method )
        raise part.inspect if last.nil?
      end
      # unconditionally brnach to the start
      method.add start
      # here we add the end of while that the branch jumps to
      #but don't link it in (not using add)
      method.current =  merge
      last
    end
    def old
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