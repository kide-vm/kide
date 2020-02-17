
module Sol
  class WhileStatement < Statement
    attr_reader :condition , :body , :hoisted

    def initialize( condition , body , hoisted = nil)
      @hoisted = hoisted
      @condition = condition
      @body = body
    end

    def to_slot( compiler )
      merge_label = SlotMachine::Label.new(self, "merge_label_#{object_id.to_s(16)}")
      cond_label = SlotMachine::Label.new(self, "cond_label_#{object_id.to_s(16)}")
      codes = cond_label
      codes << @hoisted.to_slot(compiler) if @hoisted
      codes << @condition.to_slot(compiler) if @condition.is_a?(SendStatement)
      codes << SlotMachine::TruthCheck.new(condition.to_slotted(compiler) , merge_label)
      codes << @body.to_slot(compiler)
      codes << SlotMachine::Jump.new(cond_label)
      codes << merge_label
    end

    def each(&block)
      block.call(self)
      @condition.each(&block)
      @hoisted.each(&block) if @hoisted
      @body.each(&block)
    end

    def to_s(depth = 0)
      lines =[ "while (#{@condition})" , @body.to_s(1) , "end"]
      lines.unshift( @hoisted.to_s) if @hoisted
      at_depth(depth , *lines )
    end

  end
end
