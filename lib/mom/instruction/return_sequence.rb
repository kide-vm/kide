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
      return_move = SlotLoad.new( [:message ,:return_value] , [:message , :next_message, :return_value],self)
      moves = return_move.to_risc(compiler)
      caller_reg = compiler.use_reg(:int)
      return_reg = compiler.use_reg(:int)
      compiler.reset_regs
      caller_index = Risc.resolve_to_index(:message , :caller)
      return_index = Risc.resolve_to_index(:message , :return_address)
      moves << Risc::SlotToReg.new(self, Risc.message_reg , caller_index , caller_reg)
      moves << Risc::Transfer.new(self, caller_reg , Risc.message_reg)
      moves << Risc::SlotToReg.new(self, Risc.message_reg, return_index , return_reg)
      moves << Risc::FunctionReturn.new(self, return_reg)
    end

  end

end
