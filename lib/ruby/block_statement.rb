module Ruby

  class BlockStatement < Statement
    attr_reader :send ,  :args , :body

    def initialize( send , args , body )
      @send , @args , @body = send , args , body
      raise "no bod" unless @body
    end

    def to_vool
      BlockStatement.new( @args , @body.normalize)
    end

  end
end
