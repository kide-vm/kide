module Virtual
  class NewMessageSlot < Slot
    def initialize index , type = Mystery, value = nil
      super(index , type , value )
    end
  end

  class NewReturn < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_RETURN_VALUE, type , value  )
    end
  end

  class NewSelf < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_SELF , type , value  )
    end
  end

  class NewName < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_NAME, type , value )
    end
  end
end
