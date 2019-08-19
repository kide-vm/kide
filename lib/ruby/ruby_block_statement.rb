module Ruby
  # The way the ruby parser presents a call with a block is by wrapping the
  # whole thing in a :block scope. It includes the send and the block definition.
  #
  # A block is in essence quite like a method, so the block definition is like a
  # method definition, except it is not bound to the class direcly, but the enclosing
  # method. The enclosing method also provides the scope.
  class RubyBlockStatement < Statement
    attr_reader :send ,  :args , :body

    def initialize( send , args , body )
      @send , @args , @body = send , args , body
      raise "no bod" unless @body
    end

    # This resolves to a Vool SendStatement, in fact that is mostly what it is.
    #
    # The implicitly passed block (in ruby) gets converted to the constant it is, and
    # is passed as the last argument.
    #
    def to_vool
      #block_name = "implicit_block_#{object_id}".to_sym
      lambda = Vool::LambdaExpression.new( @args.dup , @body.to_vool)
      ret = @send.to_vool
      sendd = ret.is_a?(Vool::Statements) ? ret.last : ret
      sendd.arguments << lambda
      ret
    end

  end
end
