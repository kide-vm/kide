module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        new_codes = []
        slot = Virtual::Slot
        # move the current message to new_message
        new_codes << RegisterTransfer.new( slot::MESSAGE_REGISTER , slot::NEW_MESSAGE_REGISTER )
        # and restore the message from saved value in new_message
        new_codes << GetSlot.new( slot::MESSAGE_REGISTER , slot::NEW_MESSAGE_REGISTER , slot::MESSAGE_CALLER )
        # "roll out" self and frame into their registers
        new_codes << GetSlot.new( slot::SELF_REGISTER ,slot::MESSAGE_REGISTER , slot::MESSAGE_SELF )
        new_codes << GetSlot.new( slot::FRAME_REGISTER ,slot::MESSAGE_REGISTER , slot::MESSAGE_FRAME )
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        new_codes << FunctionReturn.new( slot::MESSAGE_REGISTER , slot::MESSAGE_RETURN_ADDRESS )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual::Machine.instance.add_pass "Register::ReturnImplementation"
end
