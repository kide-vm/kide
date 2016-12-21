
# A NamedList is for local variables arguments when calling methods.
# Also temporary variables, which are local variables named by the system

# The items are named (and typed) by the objects type instance. In effect the
# variables are like instance variables

# A Message with is arguments, and a NamedList make up the two sides of message passing:
# A Message (see details there) is created by the caller and control is transferred
# A NamedList is created by the receiver
# PS: it turns out that both messages and frames are created at compile, not run-time, and
#  just constantly reused. Each message has a frame object ready and is also linked
#  to the next message.
# The better way to say above is that a message is *used* by the caller, and a frame by the callee.

# Also at runtime Messages and NamedLists remain completely "normal" objects.
# Ie they have have type and instances and so on.*
# Which resolves the dichotomy of objects on the stack or heap. Sama sama.
#
# *Alas the type for each call instance is unique.
#
module Parfait
  class NamedList < Object
    attribute :next_list

    include Indexed
    self.offset(2)  # 1 == the next_list attributes above + type. (indexed_length gets added)

  end
end
