module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        new_codes = []
        # move the current message to new_message
        new_codes << RegisterMachine.instance.mov( Virtual::Slot::MESSAGE_REGISTER , Virtual::Slot::NEW_MESSAGE_REGISTER )
        # and restore the message from saved value in new_message
        new_codes << RegisterMachine.instance.ldr( Virtual::Slot::MESSAGE_REGISTER ,Virtual::Slot::NEW_MESSAGE_REGISTER , Virtual::Slot::MESSAGE_CALLER )
        # "roll out" self and frame into their registers
        new_codes << RegisterMachine.instance.ldr( Virtual::Slot::SELF_REGISTER ,Virtual::Slot::MESSAGE_REGISTER , Virtual::Slot::MESSAGE_SELF )
        new_codes << RegisterMachine.instance.ldr( Virtual::Slot::FRAME_REGISTER ,Virtual::Slot::MESSAGE_REGISTER , Virtual::Slot::MESSAGE_FRAME )
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        new_codes << RegisterMachine.instance.ldr( :pc ,Virtual::Slot::MESSAGE_REGISTER , Virtual::Slot::MESSAGE_RETURN_ADDRESS )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after ReturnImplementation , CallImplementation 
end
