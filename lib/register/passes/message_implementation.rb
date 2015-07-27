module Register
  # This implements the creation of a new message object
  #
  # It does so by loading the next message into the new_message register.
  #
  # Messages are created at compile time and form a linked list which actually never changes.
  # We just grab the next item of the list.

  # Just as a reminder: a message object is used for a send and holds return address/message
  # and arguments + self
  # while frames are used by a method and hold local and temporary variables

  # This was at first a little surprising, but it actually similar in c. When a c function pops to
  # stack, it doesn't create a new stack. Just increments some index. The storage/stack is reused,
  # stays constant. (until such time it runs out, which we haven't covered yet)
  #
  # Even stranger at first was the notion that the caller does not have to be set either.
  # That is contstant (a compile time property) too. It's a bit like when calling someone,
  #

  class MessageImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a?(Virtual::NewMessage)
        # load the new_message from message by index, simple get_slot
        new_codes = [ Register.get_slot(code, :message , :next_message , Register.resolve_to_register(:new_message))]
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::MessageImplementation"
end
