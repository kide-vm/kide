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
      cond_val = condition.compile(context , into)
      #set up branches for bodies
      # jump to end if done
      last = nil
      body.each do |part|
        last = part.compile(context , into )
        puts "compiled in while #{last.inspect}"
      end
      #jump back to test
      return last
    end
  end

  
end