
# A NamedList is used to store local variables and arguments when calling methods.
# Also temporary variables, which are local variables named by the system

# The items are named (and typed) by the objects type instance. In effect the
# variables are like instance variables

# A Message with is arguments, and a NamedList make up the two sides of message passing:
# A Message (see details there) is created by the caller and control is transferred
# A NamedList is created by the receiver
# PS: it turns out that both messages and named_lists are created at compile, not run-time, and
#  just constantly reused. Each message has two named_list object ready and is also linked
#  to the next message.
# The better way to say above is that a message is *used* by the caller, and a named_list
#  by the callee.

# Also at runtime Messages and NamedLists remain completely "normal" objects.
# Ie they have have type and instances and so on.*
# Which resolves the dichotomy of objects on the stack or heap. Sama sama.
#
# *Alas the type for each call instance is unique.
#
module Parfait
  class NamedList < Object

    def self.type_for( arguments )
      my_class = Parfait.object_space.classes[:NamedList]
      Type.for_hash( my_class , {type: my_class.instance_type}.merge(arguments))
    end
  end
end
