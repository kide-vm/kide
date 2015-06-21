module Register
  class ReturnImplementation
    def run block
      slot = Virtual::Slot
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        new_codes = []
        # move the current message to new_message
        new_codes << RegisterTransfer.new( slot::MESSAGE_REGISTER , slot::NEW_MESSAGE_REGISTER )
        # and restore the message from saved value in new_message
        new_codes << GetSlot.new( slot::NEW_MESSAGE_REGISTER , Virtual::CALLER_INDEX , slot::MESSAGE_REGISTER)
        # "roll out" self and frame into their registers
        new_codes << GetSlot.new( slot::MESSAGE_REGISTER , Virtual::SELF_INDEX , slot::SELF_REGISTER )
        new_codes << GetSlot.new( slot::MESSAGE_REGISTER , Virtual::FRAME_INDEX , slot::FRAME_REGISTER )
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        new_codes << FunctionReturn.new( slot::MESSAGE_REGISTER , Virtual::RETURN_INDEX )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::ReturnImplementation"
end
