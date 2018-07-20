module Ruby
  # The way the ruby parser presents a call with a block is by wrapping the
  # whole thing in a :block scope. It includes the send and the block definition.
  #
  # A block is in essence quite like a method, so the block definition is like a
  # method definition, except it is not bound to the class direcly, but the enclosing
  # method. The enclosing method also provides the scope.
  class BlockStatement < Statement
    attr_reader :send ,  :args , :body

    def initialize( send , args , body )
      @send , @args , @body = send , args , body
      raise "no bod" unless @body
    end

    # In Vool we "hoist" the block definition through a local assignment, much
    # as we would other complex args (bit like in the Normalizer)
    # The block is then passed as a normal variable to the send. In other words, the
    # BlockStatement resolves to a list of Statements, the last of which is the send
    #
    def to_vool
      block_name = "implicit_block_#{object_id}".to_sym
      block = Vool::BlockStatement.new( @args.dup , @body.to_vool)
      assign = Vool::LocalAssignment.new( block_name , block)
      sendd = @send.to_vool
      if(sendd.is_a?(Vool::Statements))
        ret = sendd
        sendd = sendd.last
      else
        ret = Vool::Statements.new([sendd])
      end
      sendd.arguments << LocalVariable.new(block_name).to_vool
      ret.prepend(assign)
      ret
    end

  end
end
