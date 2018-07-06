module Vool
  class BlockStatement < Statement
    attr_reader :args , :body , :clazz

    def initialize( args , body , clazz = nil)
      @args , @body = args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    # because of normalization (of send), slot_definition is called first,
    # to assign the block to a variable.
    #
    # This means we do the compiler here (rather than to_mom, which is in
    # fact never called)
    def slot_definition(compiler)
      @parfait_block = to_parfait(compiler)
      compiler.add_constant(@parfait_block)
      return Mom::SlotDefinition.new(Mom::IntegerConstant.new(1) , [])
    end

    def to_mom( compiler )
#      raise "should not be called "
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def normalize
      BlockStatement.new( @args , @body.normalize)
    end

    private
    def to_parfait(compiler)

    end

  end
end
