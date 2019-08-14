
module Vool
  class IfStatement < Statement

    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end

    def to_mom( compiler )
      true_label  = Mom::Label.new( self , "true_label_#{object_id.to_s(16)}")
      false_label = Mom::Label.new( self , "false_label_#{object_id.to_s(16)}")
      merge_label = Mom::Label.new( self , "merge_label_#{object_id.to_s(16)}")

      head = Mom::TruthCheck.new(condition.slot_definition(compiler) , false_label)
      head << true_label
      head << if_true.to_mom(compiler)   if @if_true
      head << Mom::Jump.new(merge_label) if @if_false
      head << false_label
      head << if_false.to_mom(compiler)  if @if_false
      head << merge_label                if @if_false
      head
    end

    def each(&block)
      block.call(condition)
      @if_true.each(&block) if @if_true
      @if_false.each(&block) if @if_false
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

    def to_s(depth = 0)
      parts = ["if (#{@condition})" , @body.to_s(depth + 1) ]
      parts += ["else" ,  "@if_false.to_s(depth + 1)"] if(@false)
      parts << "end"
      at_depth(depth , *parts )
    end
  end
end
