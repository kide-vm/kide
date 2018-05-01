require_relative "normalizer"
module Vool
  class IfStatement < Statement
    include Normalizer

    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end

    def normalize
      cond , rest = *normalize_name(@condition)
      fals = @if_false ? @if_false.normalize : nil
      me = IfStatement.new(cond , @if_true.normalize, fals)
      return me unless rest
      rest << me
      rest
    end

    def to_mom( method )
      if_false ? full_if(method) : simple_if(method)
    end

    def simple_if(method)
      true_label  = Mom::Label.new( "true_label_#{object_id.to_s(16)}")
      merge_label = Mom::Label.new( "merge_label_#{object_id.to_s(16)}")

      head = Mom::TruthCheck.new(condition.slot_definition(method) , merge_label)
      head << true_label
      head << if_true.to_mom(method)
      head << merge_label
    end

    def full_if(method)
      true_label  = Mom::Label.new( "true_label_#{object_id.to_s(16)}")
      false_label = Mom::Label.new( "false_label_#{object_id.to_s(16)}")
      merge_label = Mom::Label.new( "merge_label_#{object_id.to_s(16)}")

      head = Mom::TruthCheck.new(condition.slot_definition(method) , false_label)
      head << true_label
      head << if_true.to_mom(method)
      head << Mom::Jump.new(merge_label)
      head << false_label
      head << if_false.to_mom(method)
      head << merge_label
    end

    def each(&block)
      block.call(condition)
      @if_true.each(&block)
      @if_false.each(&block) if @if_false
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

  end
end
