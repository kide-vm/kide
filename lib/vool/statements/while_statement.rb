require_relative "normalizer"

module Vool
  class WhileStatement < Statement
    include Normalizer
    attr_reader :condition , :statements

    def initialize( condition , statements )
      @condition = condition
      @statements = statements
      simplify_condition
    end

    def normalize(method)
      cond , rest = *normalize_name(@condition)
      me = WhileStatement.new(cond , @statements.normalize(method))
      return me unless rest
      rest << me
    end

    def to_mom( method )
      statements =   @statements.to_mom( method )
      condition , hoisted  = hoist_condition( method )
      cond = Mom::TruthCheck.new(condition.to_mom(method))
      check = Mom::WhileStatement.new(  cond , statements  )
      check.hoisted = hoisted.to_mom(method) if hoisted
      check
    end

    def simplify_condition
      return unless @condition.is_a?(ScopeStatement)
      @condition = @condition.first if @condition.single?
    end

    def collect(arr)
      @condition.collect(arr)
      @statements.collect(arr)
      super
    end

  end
end
