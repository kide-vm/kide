module Vool
  class IfStatement < Statement
    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
      simplify_condition
    end

    def to_mom( method )
      if_true = @if_true.to_mom( method )
      if_false = @if_false.to_mom( method )
      make_condition( if_true , if_false )
    end

    # conditions in ruby are almost always method sends (as even comparisons are)
    # currently we just deal with straight up values which get tested
    # for the funny ruby logic (everything but false and nil is true)
    def make_condition( if_true , if_false )
      merge = Mom::Noop.new(:merge)
      if_true = [if_true] unless if_true.is_a?(Array)
      if_true << Mom::Jump.new(merge)
      if_false = [if_false] unless if_false.is_a?(Array)
      if_false << Mom::Jump.new(merge)
      check = Mom::TruthCheck.new( @condition , if_true , if_false , merge)
      [ check , if_true , if_false , merge ]
    end

    def collect(arr)
      @if_true.collect(arr)
      @if_false.collect(arr)
      super
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
