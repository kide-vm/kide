module SlotLanguage
  class LoadMaker
    attr_reader :left , :right

    def initialize(left , right)
      @left = left
      @right = right
      raise "No Slot #{left}" unless left.is_a?(SlotMaker)
      raise "No Slot #{right}" unless right.is_a?(SlotMaker)
    end

    def to_slot(compiler)
      left_d = @left.slot_def(compiler)
      right_d = @right.slot_def(compiler)
      SlotMachine::SlotLoad.new("source" , left_d , right_d)
    end
  end
end
