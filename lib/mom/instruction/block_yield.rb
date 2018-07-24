module Mom

  # A BlockYield calls an argument block. All we need to know is the index
  # of the argument, and the rest is almost as simple as a SimpleCall

  class BlockYield < Instruction
    attr :arg_index

    def initialize(index)
      @arg_index = index
    end

    def to_s
      "BlockYield[#{arg_index}] "
    end

    def to_risc(compiler)
      block = compiler.use_reg( :Block )
      return_label = Risc.label(self, "continue_#{object_id}")
      save_return =  SlotLoad.new([:message,:next_message,:return_address],[return_label],self)
      moves = save_return.to_risc(compiler)
      moves << Risc.slot_to_reg( self , Risc.message_reg ,:arguments , block)
      moves << Risc.slot_to_reg( self , block ,arg_index , block)

      moves << Risc.slot_to_reg(self, Risc.message_reg , :next_message , Risc.message_reg)
      moves << Risc::DynamicJump.new(self, block )
      moves << return_label
    end
  end

end
