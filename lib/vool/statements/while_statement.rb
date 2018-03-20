require_relative "normalizer"

module Vool
  class WhileStatement < Statement
    include Normalizer
    attr_reader :condition , :body

    def initialize( condition , body )
      @condition = condition
      @body = body
    end

    def normalize
      cond , rest = *normalize_name(@condition)
      me = WhileStatement.new(cond , @body.normalize)
      return me unless rest
      rest << me
      rest
    end

    def to_mom( method )
      merge_label = Mom::Label.new( "merge_label_#{object_id}")
      cond_label = Mom::Label.new( "cond_label_#{object_id}")
      cond_label << Mom::TruthCheck.new(condition.slot_definition(method) , merge_label)
      cond_label << @body.to_mom(method)
      cond_label << Mom::Jump.new(cond_label)
      cond_label << merge_label
    end

    def each(&block)
      block.call(self)
      block.call(@condition)
      @body.each(&block)
    end

  end
end
