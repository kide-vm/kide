
module Vool
  class WhileStatement < Statement
    attr_reader :condition , :body , :hoisted

    def initialize( condition , body , hoisted = nil)
      @hoisted = hoisted
      @condition = condition
      @body = body
    end

    def to_mom( compiler )
      merge_label = Mom::Label.new(self, "merge_label_#{object_id.to_s(16)}")
      cond_label = Mom::Label.new(self, "cond_label_#{object_id.to_s(16)}")
      codes = cond_label
      codes << @hoisted.to_mom(compiler) if @hoisted
      codes << @condition.to_mom(compiler) if @condition.is_a?(SendStatement)
      codes << Mom::TruthCheck.new(condition.slot_definition(compiler) , merge_label)
      codes << @body.to_mom(compiler)
      codes << Mom::Jump.new(cond_label)
      codes << merge_label
    end

    def each(&block)
      block.call(self)
      @condition.each(&block)
      @hoisted.each(&block) if @hoisted
      @body.each(&block)
    end

    def to_s(depth = 0)
      at_depth(depth , "while (#{@condition})" , @body.to_s(depth + 1) , "end" )
    end

  end
end
