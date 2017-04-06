module Vool
  class WhileStatement < Statement
    attr_reader :condition , :statements

    def initialize( condition , statements )
      @condition = condition
      @statements = statements
      simplify_condition
    end

    def simplify_condition
      return unless @condition.is_a?(ScopeStatement)
      @condition = @condition.first if @condition.single?
    end

  end
end
