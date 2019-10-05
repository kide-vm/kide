module SlotLanguage
  class LoadMaker
    attr_reader :left , :right

    def initialize(left , right)
      @left = left
      @right = right
      raise "No Slot #{left}" unless left.is_a?(SlotMaker)
      raise "No Slot #{right}" unless right.is_a?(SlotMaker)
    end
  end
end
