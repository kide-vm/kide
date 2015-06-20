module Virtual

  # Slots in the Frame a re represented by instances of FrameSlot

  # Slots in the Frame are local or temporary varialbes in a message
  class FrameSlot < Slot
    def initialize index , type = Unknown, value = nil
      super
    end
  end

end
