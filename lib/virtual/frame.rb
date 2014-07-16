module Virtual
  # A Message and a Frame make up the two sides of message passing:
  # A Message (see details there) is created by the sender and control is transferred
  # A Frame is created by the receiver

  # In static languages these two objects are one, because the method is known at compile time. 
  # In that case the whole frame is usually on the stack, for leaves even omitted and all data is held in registers
  #
  # In a dynamic language the method is dynamically resolved, and so the size of the frame is not know to the caller
  # Also exceptions (with the possibility of retry) and the idea of being able to take and store bindings
  # make it to say the very least unsensibly tricky to store them on the stack. So we don't.

  # Also at runtime Messages and frames remain completely "normal" objects

  class Frame
    def initialize variables
      @variables = variables
    end
    attr_accessor :variables
  end
end
