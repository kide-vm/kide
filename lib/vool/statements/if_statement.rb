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
      merge = Mom::Noop.new(:merge)
      if_true = add_jump(@if_true.to_mom( method ) , merge)
      if_false = add_jump(@if_false.to_mom( method ) , merge)
      cond = hoist_condition( method )
      check = Mom::TruthCheck.new( cond.pop , if_true , if_false , merge)
      [ *cond , check , if_true , if_false , merge ]
    end

    def hoist_condition( method )
      return [@condition] if @condition.is_a?(Vool::Named)
      local = method.create_tmp
      assign = LocalAssignment.new( local , @condition).to_mom(method)
      [assign , Vool::LocalVariable.new(local)]
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
