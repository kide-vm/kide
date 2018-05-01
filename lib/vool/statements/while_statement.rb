require_relative "normalizer"

module Vool
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

    def to_mom( method )
      merge_label = Mom::Label.new( "merge_label_#{object_id.to_s(16)}")
      cond_label = Mom::Label.new( "cond_label_#{object_id.to_s(16)}")
      codes = cond_label
      codes << @hoisted.to_mom(method) if @hoisted
      codes << Mom::TruthCheck.new(condition.slot_definition(method) , merge_label)
      codes << @body.to_mom(method)
      codes << Mom::Jump.new(cond_label)
      codes << merge_label
    end

    def each(&block)
      block.call(self)
      block.call(@condition)
      @hoisted.each(&block) if @hoisted
      @body.each(&block)
    end

  end
end
