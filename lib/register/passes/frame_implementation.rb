module Register
  # This implements the creation of a new frame object.
  # Or to be more precise, it makes the frame available in a register, as the message (any message)
  #  carries a frame around which is reused.

  # Just as a reminder: a message object is used to send and holds return address/message
  # and arguments + self
  # frames are used by a method and hold local and temporary variables


  class FrameImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a?(Virtual::NewFrame)
        # load the frame from message by index, simple get_slot
        new_codes = [ Register.get_slot( :message , :frame , Register.resolve_to_register(:frame))]
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::FrameImplementation"
end
