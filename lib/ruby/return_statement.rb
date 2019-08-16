module Ruby
  class ReturnStatement < Statement
    include Normalizer

    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def to_vool
      val , hoisted = *normalized_vool(@return_value)
      me = Vool::ReturnStatement.new(val)
      return me unless hoisted
      Vool::Statements.new( hoisted ) << me
    end

    def to_s(depth = 0)
      at_depth(depth , "return #{@return_value.to_s}")
    end
  end
end
