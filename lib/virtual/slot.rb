module Virtual
  # Slots are named, or rather indexed, storage locations that are typed.
  # Four of those locations exist and those correspond to subclasses:
  # - the message that has been received: MessageSlot
  # - the frame of the method that is executing (local variables): FrameSlot
  # - self as an object: SelfSlot
  # - a message that will be sent, NewMessageSlot

  # additionally frame, self and return are slots in Message and NewMessage

  class Slot < Object
    MESSAGE_REGISTER = :r0
    SELF_REGISTER = :r1
    FRAME_REGISTER = :r2
    NEW_MESSAGE_REGISTER = :r3

    MESSAGE_CALLER = 0
    MESSAGE_RETURN_ADDRESS = 1
    MESSAGE_EXCEPTION_ADDRESS = 2
    MESSAGE_SELF = 3
    MESSAGE_NAME = 4
    MESSAGE_RETURN_VALUE = 5
    MESSAGE_FRAME = 6
    MESSAGE_PAYLOAD = 7

    attr_accessor :index , :type , :value
    private #abstract base class
    def initialize index , type , value
      @index = index
      @type = type
      @value = value
    end
  end

  class MessageSlot < Slot
    def initialize index , type = Mystery , value = nil
      super(index ,type , value )
    end
  end
  class FrameSlot < Slot
    def initialize index , type = Mystery, value = nil
      super
    end
  end
  class SelfSlot < Slot
    def initialize index , type = Mystery, value = nil
      super
    end
  end
  class NewMessageSlot < Slot
    def initialize index , type = Mystery, value = nil
      super(index , type , value )
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
  class Name < MessageSlot
    def initialize type = Mystery, value = nil
      super( MESSAGE_NAME , type , value  )
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
