module Mom

  #SlotMove is a SlotLoad where the right side is a slot, just like the left.
  class SlotMove < SlotLoad

    def initialize(left , right)
      right = SlotDefinition.new(right.shift , right) if right.is_a? Array
      super(left , right)
    end
    
    def to_risc(context)
      Risc::Label.new(self,"SlotMove")
    end
  end
end
