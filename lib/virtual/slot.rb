module Virtual
  # Slots are named, or rather indexed, storage locations that are typed.
  # Four of those locations exist and those correspond to subclasses:
  # - the message that has been received: MessageSlot
  # - the frame of the method that is executing (local variables): FrameSlot
  # - self as an object: SelfSlot
  # - a message that will be sent, NewMessageSlot
  
  # additionally frame, self and return are slots in Message and NewMessage

  class Slot < Value
    RETURN = 0
    SELF = 1

    attr_accessor :index , :type
    private #abstract base class
    def initialize index , type
      @index = index
      @type = type
    end
  end
  
  class MessageSlot < Slot
    def initialize index , type = Mystery
      super
    end
  end
  class FrameSlot < Slot
    def initialize index , type = Mystery
      super
    end
  end
  class SelfSlot < Slot
    def initialize index , type = Mystery
      super
    end
  end
  class NewMessageSlot < Slot
    def initialize index , type = Mystery
      super
    end
  end

  class Return < MessageSlot
    def initialize type = Mystery
      super( RETURN , type )
    end
  end
  class NewReturn < NewMessageSlot
    def initialize type = Mystery
      super( RETURN , type )
    end
  end
  class Self < MessageSlot
    def initialize type = Mystery
      super( SELF , type )
    end
  end
  class NewSelf < NewMessageSlot
    def initialize type = Mystery
      super( SELF , type )
    end
  end

end
