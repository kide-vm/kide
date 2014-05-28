module Ast
  class WhileExpression < Expression
    attr_reader  :condition, :body
    def initialize condition, body
      @condition , @body = condition , body
    end
    def inspect
      self.class.name + ".new(" + condition.inspect + ", "  + body.inspect + " )"  
    end
    def to_s
      "while(#{condition}) do\n" + body.join("\n") + "\nend\n"
    end
    def attributes
      [:condition, :body]
    end
    def compile context , into
      while_block = into.new_block "#{into.name}_while"
      ret = while_block.new_block "#{into.name}_return"
      cond_val = condition.compile(context , while_block)
      puts "compiled while condition #{cond_val.inspect}"
      while_block.b ret , condition_code: cond_val.operator
      last = nil
      body.each do |part|
        last = part.compile(context , while_block )
        puts "compiled in while #{last.inspect}"
      end
      while_block.b while_block
      puts "compile while end"
      into.insert_at ret
      return last
    end
  end

  
end