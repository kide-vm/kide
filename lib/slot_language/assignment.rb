module SlotLanguage
  # A Assignment makes SlotLoad. That means it stores the information
  # to be able to create a SlotLoad
  #
  # Just like the SlotLoad stores two Slots, here we store two SlotMakers
  #
  class Assignment
    # The two SlotMakers that become Slots in to_slot
    attr_reader :left , :right

    def initialize(left , right)
      @left = left
      @right = right
      raise "No Slot #{left}" unless left.is_a?(SlotMaker)
      raise "No Slot #{right}" unless right.is_a?(SlotMaker)
    end

    # create the SlotLoad, by creating the two Slots from the SlotMakers
    def to_slot(compiler)
      left_d = @left.to_slot(compiler)
      right_d = @right.to_slot(compiler)
      SlotMachine::SlotLoad.new("source" , left_d , right_d)
    end
  end
end
