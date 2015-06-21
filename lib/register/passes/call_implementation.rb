module Register

  # Defines the method call, ie
  # - move the new_message to message
  # - unroll self and
  # - register call

  # all in all, quite the reverse of a return

  class CallImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodCall
        new_codes = []
        slot = Virtual::Slot
        # move the current new_message to message
        new_codes << RegisterTransfer.new( slot::NEW_MESSAGE_REGISTER , slot::MESSAGE_REGISTER )
        # "roll out" self into its register
        new_codes << GetSlot.new( slot::SELF_REGISTER ,slot::MESSAGE_REGISTER , Virtual::MESSAGE_SELF )
        # do the register call
        new_codes << FunctionCall.new( code.method )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::CallImplementation"
end
