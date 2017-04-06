module Vool
  class IfStatement < Statement
    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = [])
      @condition = cond
      @if_true = if_true
      @if_false = if_false
      simplify_condition
    end

    def simplify_condition
      return unless @condition.is_a?(ScopeStatement)
      @condition = @condition.first if @condition.single?
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end
  end
end
