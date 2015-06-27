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
        new_codes << RegisterTransfer.new( RegisterReference.new_message_reg , RegisterReference.message_reg )
        # "roll out" self into its register
        new_codes << GetSlot.new( RegisterReference.message_reg , Virtual::SELF_INDEX, RegisterReference.self_reg )
        # do the register call
        new_codes << FunctionCall.new( code.method )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::CallImplementation"
end
