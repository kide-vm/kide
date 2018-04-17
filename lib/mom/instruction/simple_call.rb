module Mom

  # A SimpleCall is just that, a simple call. This could be called a function call too,
  # meaning we managed to resolve the function at compile time and all we have to do is
  # actually call it.
  #
  # As the call setup is done beforehand (for both simple and cached call), the
  # calling really means mostly jumping to the address. Simple.
  #
  class SimpleCall < Instruction
    attr_reader :method

    def initialize(method)
      @method = method
    end

    def to_s
      "SimpleCall #{@method.name}"
    end
    # To call the method, we determine the jumpable address (method.binary), move that
    # into a register and issue a FunctionCall
    #
    # For returning, we add a label after the call, and load it's address into the
    # return_address of the next_message, for the ReturnSequence to pick it up.
    def to_risc(compiler)
      jump_address = compiler.use_reg(:Object)
      return_label = Risc::Label.new(self,"continue_#{object_id}")
      save_return =  SlotLoad.new([:message,:next_message,:return_address],[return_label],self)
      moves = save_return.to_risc(compiler)
      moves << Risc.slot_to_reg(self, :message , :next_message , Risc.message_reg)

      moves << Risc.load_constant(self , method.binary , jump_address)
      moves << Risc::FunctionCall.new(self, method ,jump_address)

      moves << return_label
    end

  end

end
