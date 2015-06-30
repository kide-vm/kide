module Virtual

  # Slots in the Frame a re represented by instances of FrameSlot

  # Slots in the Frame are local or temporary variables in a message
  class FrameSlot < Slot
    def initialize type = Unknown, value = nil
      super
    end

    def object_name
      return :frame
    end
  end

end
