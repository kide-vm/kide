
# A Frame is set up by functions that use local variables or temporary variables
# in fact temporary variables are local variables named by the system

# It allows for access to those variables basically

# A Message and a Frame make up the two sides of message passing:
# A Message (see details there) is created by the caller and control is transferred
# A Frame is created by the receiver
# PS: it turns out that both messages and frames are created at compile, not run-time, and
#  just constantly reused. Each message has a frame object ready and ist also linked
#  to the next message.
# The better way to say above is that a message is *used* by the caller, and a frame by the callee.

# Also at runtime Messages and Frames remain completely "normal" objects. Ie have layouts and so on.
# Which resolves the dichotomy of objects on the stack or heap. Sama sama.

module Parfait
  class Frame < Object
    attribute :next_frame

    include Indexed
    self.offset(2)  # 1 == the next_frame attributes above + layout. (indexed_length gets added)

  end
end
