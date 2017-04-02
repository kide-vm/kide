module Vool
  class IfStatement < Statement
    attr_accessor :condition , :if_true , :if_false

    def initialize( cond  = nil)
      @condition = cond
      @if_true = []
      @if_false = []
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end
  end
end
