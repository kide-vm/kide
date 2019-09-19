module Ruby
  class MethodStatement < Statement
    attr_reader :name, :args , :body

    def initialize( name , args , body)
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
    end

    # At the moment normalizing means creating implicit returns for some cases
    # see replace_return for details.
    def normalized_body
      return replace_return( @body ) unless  @body.is_a?(Statements)
      body = Statements.new( @body.statements.dup )
      body << replace_return( body.pop )
    end

    def to_vool
      body = normalized_body
      Vool::MethodExpression.new( @name , @args.dup , body.to_vool)
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
