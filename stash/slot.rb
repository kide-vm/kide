module Virtual
  # A slot is a slot in an object. It is the storage location for a value.
  #             (Remember, values are typed)
  # From a memory perspective a slot is an index into an array (the object)
  # The mapping into arrays is a straightforward matter, but happens in the
  # next level down, the register machine.

  # Four known objects exist and those correspond to subclasses:
  # - the message that has been received: MessageSlot
  # - the frame of the method that is executing (local variables): FrameSlot
  # - self as an object: SelfsSlot
  # - a message that will be sent, NewMessageSlot

  # additionally frame, self and return are slots in Message and NewMessage

  # Slot has a lot of small subclasses
  # Names for the slots avoid indexes


end
