module Ruby
  class MethodStatement < Statement
    attr_reader :name, :args , :body , :clazz

    def initialize( name , args , body , clazz = nil)
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    def to_vool
      if @body.is_a?(Statements)
          @body << replace_return( @body.pop )
      else
        @body = replace_return( @body )
      end
      Vool::MethodExpression.new( @name , @args.dup , @body.to_vool)
    end

    def replace_return(statement)
      case statement
      when SendStatement , YieldStatement, Variable , Constant
         return ReturnStatement.new( statement )
      when IvarAssignment
        ret = ReturnStatement.new( InstanceVariable.new(statement.name) )
        return Statements.new([statement , ret])
      when LocalAssignment
        ret = ReturnStatement.new( LocalVariable.new(statement.name) )
        return Statements.new([statement , ret])
      when ReturnStatement , IfStatement , WhileStatement ,RubyBlockStatement
        return statement
      else
        raise "Not implemented implicit return #{statement.class}"
      end
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def #{name}(#{arg_str})" , @body.to_s(depth + 1) , "end")
    end

  end
end
