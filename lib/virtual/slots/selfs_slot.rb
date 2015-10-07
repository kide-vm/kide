module Virtual

  # Self (the receiver of the current message) is a Slot in the Message.
  # The current self in the current message and if the current message
  # want to send a message it puts the new self into the next_message.
  #
  # The slot in the Message is represented by instances of class Self
  # (and slots in the next_message by instances of NewSelf)
  #
  # Additionally the current Self is represented as it's own top-level object.
  # If self is an Object one can refer to it's instance variables as Slots in SelfsSlot
  #
  # In Summary: class Self represents the self object and SelfsSlot instances variables of
  #  that object
  #
  class SelfsSlot < Slot
    def initialize index , type , value = nil
      @index = index
      super( type , value )
    end
    attr_reader :index
    def object_name
      :self
    end
  end
end
