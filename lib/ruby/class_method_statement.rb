module Ruby
  class ClassMethodStatement < MethodStatement

    def to_vool
      body = normalized_body
      Vool::ClassMethodExpression.new( @name , @args.dup , body.to_vool)
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def self.#{name}(#{arg_str})\n#{@body.to_s(depth + 1)}\nend")
    end

  end
end
