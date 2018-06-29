module Vool
  class BlockStatement < Statement
    attr_reader :args , :body , :clazz

    def initialize( args , body , clazz = nil)
      @args , @body = args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    def to_mom( _ )
      raise "should not be called (call create_objects)"
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def normalize
      BlockStatement.new( @args , @body.normalize)
    end

    def create_objects(clazz)
    end


  end
end
