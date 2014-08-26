module Register
  # This implements call logic, which is simply like a c call (not send, that involves lookup and all sorts)
  #
  # The only target for a call is a MethodDefinition, so we just need to get the address for the code
  # and call it.
  #
  # The only slight snag is that we would need to assemble before getting the address, but to assemble
  # we'd have to have finished compiling. So we need a reference.
  class CallImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::FunctionCall
        call = RegisterMachine.instance.call( code.method )
        block.replace(code , [call] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after CallImplementation , SetImplementation
end
