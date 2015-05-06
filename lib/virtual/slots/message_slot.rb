module Virtual
  # The message that is being processed has a layout as per the constant above
  class MessageSlot < Slot
    def initialize index , type = Mystery , value = nil
      super(index ,type , value )
    end
  end

  class Return < MessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_RETURN_VALUE , type , value  )
    end
  end

  class Self < MessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_SELF , type , value  )
    end
  end

  # Name of the current message
  class Name < MessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_NAME , type , value  )
    end
  end
end
