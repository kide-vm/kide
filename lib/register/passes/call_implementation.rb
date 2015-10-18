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
        # move the current new_message to message
        new_codes << RegisterTransfer.new(code, Register.new_message_reg , Register.message_reg )
        # do the register call
        new_codes << FunctionCall.new( code , code.method )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::CallImplementation"
end
