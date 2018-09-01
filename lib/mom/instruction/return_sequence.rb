module Mom

  # The ReturnSequence models the return from a method.
  #
  # This involves the jump to the return address stored in the message, and
  # the reinstantiation of the previous message.
  #
  # The machine (mom) only ever "knows" one message, the current message.
  # Messages are a double linked list, calling involves going forward,
  # returning means going back.
  #
  # The return value of the current message is transferred into the return value of the
  # callers return value during the swap of messages, and just before the jump.
  #
  # The callers perspective of a call is the magical apperance of a return_value
  # in it's message at the instruction after the call.
  #
  # The instruction is not parameterized as it translates to a constant
  # set of lower level instructions.
  #
  class ReturnSequence < Instruction
    def to_risc(compiler)
      compiler.reset_regs
      builder = compiler.builder(self)
      builder.build do
        object! << message[:return_value]
        caller_reg! << message[:caller]
        caller_reg[:return_value] << object
        factory? << Parfait.object_space.get_factory_for(:Message)
        next_message! << factory[:next_object]
        message[:next_message] << next_message
        factory[:next_object] << message
      end
      compiler.reset_regs
      builder.build do
        return_address! << message[:return_address]
        return_address << return_address[ Parfait::Integer.integer_index]
        message << message[:caller]
        return_address.function_return
      end
    end

    def to_s
      "ReturnSequence"
    end
  end

end
