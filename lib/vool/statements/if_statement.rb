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
      merge = Mom::Noop.new(:merge)
      make_condition( add_jump(if_true,merge) , add_jump(if_false,merge) , merge)
    end

    # conditions in ruby are almost always method sends (as even comparisons are)
    # currently we just deal with straight up values which get tested
    # for the funny ruby logic (everything but false and nil is true)
    def make_condition( if_true , if_false , merge)
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

    private
    def add_jump( block , merge)
      block = [block] unless block.is_a?(Array)
      block << Mom::Jump.new(merge)
      block
    end
  end
end
