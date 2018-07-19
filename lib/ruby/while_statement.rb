require_relative "normalizer"

module Ruby
  class WhileStatement < Statement
    include Normalizer
    attr_reader :condition , :body , :hoisted

    def initialize( condition , body , hoisted = nil)
      @hoisted = hoisted
      @condition = condition
      @body = body
    end

    def normalize
      cond , rest = *normalize_name(@condition)
      WhileStatement.new(cond , @body.normalize , rest)
    end

    def to_s(depth = 0)
      at_depth(depth , "while (#{@condition})" , @body.to_s(depth + 1) , "end" )
    end

  end
end
