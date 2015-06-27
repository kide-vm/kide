module Register
  class ReturnImplementation
    def run block
      slot = Virtual::Slot
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        new_codes = []
        # move the current message to new_message
        new_codes << RegisterTransfer.new( RegisterReference.message_reg , RegisterReference.new_message_reg )
        # and restore the message from saved value in new_message
        new_codes << GetSlot.new( RegisterReference.new_message_reg , Virtual::CALLER_INDEX , RegisterReference.message_reg)
        # "roll out" self and frame into their registers
        new_codes << GetSlot.new( RegisterReference.message_reg , Virtual::SELF_INDEX , RegisterReference.self_reg )
        new_codes << GetSlot.new( RegisterReference.message_reg , Virtual::FRAME_INDEX , RegisterReference.frame_reg )
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        new_codes << FunctionReturn.new( RegisterReference.message_reg , Virtual::RETURN_INDEX )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::ReturnImplementation"
end
