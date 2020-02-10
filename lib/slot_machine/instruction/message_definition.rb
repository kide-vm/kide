module SlotMachine
  class MessageDefinition < SlotDefinition

    def initialize(slots)
      super(:message , slots)
    end

    def known_name
      :message
    end

    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      type = :Message
      right = compiler.use_reg( type )
      slots = @slots.dup
      left = Risc.message_reg
      left = left.resolve_and_add( slots.shift , compiler)
      reg = compiler.current.register
      while( !slots.empty? )
        left = left.resolve_and_add( slots.shift , compiler)
      end
      return reg
    end

  end
end
