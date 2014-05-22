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
      ret = into.new_block "#{into.name}_return_#{hash}"
      while_block = into.new_block "#{into.name}_while_#{hash}"
      cond_val = condition.compile(context , while_block)
      while_block.bne ret
      last = nil
      body.each do |part|
        last = part.compile(context , while_block )
        puts "compiled in while #{last.inspect}"
      end
      while_block.b while_block
      into.insert_at_end
      return last
    end
  end

  
end