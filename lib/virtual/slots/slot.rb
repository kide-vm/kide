module Virtual
  # A slot is a slot in an object. It is the storage location for a value.
  #             (Remember, values are typed)
  # From a memory perspective a slot is an index into an array (the object)
  # The mapping into arrays is a straightforward matter, but happens in the
  # next level down, the register machine.

  # Four known objects exist and those correspond to subclasses:
  # - the message that has been received: MessageSlot
  # - the frame of the method that is executing (local variables): FrameSlot
  # - self as an object: SelfSlot
  # - a message that will be sent, NewMessageSlot

  # additionally frame, self and return are slots in Message and NewMessage

  # Slot has a lot of small subclasses
  # Names for the slots avoid indexes

  class Slot < Object

    # the name of the object of a slot is a symbol that represents what the class name describes
    # ie it is one of :message , :self , :frame , :new_message
    # one of the objects the machine works on.
    def object_name
      raise "abstract called #{self}"
    end

    attr_accessor :type , :value

    private #abstract base class

    def initialize type , value
      @type = type
      @value = value
    end
  end

end

require_relative "message_slot"
require_relative "self_slot"
require_relative "frame_slot"
require_relative "new_message_slot"
