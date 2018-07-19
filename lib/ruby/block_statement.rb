module Vool

  class BlockStatement < Statement
    attr_reader :args , :body , :clazz

    def initialize( args , body , something_really_else)
      @args , @body = args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    def normalize
      BlockStatement.new( @args , @body.normalize)
    end

  end
end
