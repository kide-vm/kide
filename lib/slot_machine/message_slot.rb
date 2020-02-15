module SlotMachine
  class MessageSlot < Slot

    def initialize(slots)
      super(slots)
    end

    def known_name
      :message
    end
    alias :known_object :known_name 

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

    # load the data in const_reg into the slot that is named by slot symbols
    # actual lifting is done by RegisterValue resolve_and_add
    #
    # Note: this is the left hand case, the right hand being to_register
    #       They are very similar (apart from the final reg_to_slot here) and should
    #       most likely be united
    def reduce_and_load(const_reg , compiler , original_source )
      left_slots = slots.dup
      raise "Not Message #{object}" unless known_object == :message
      left = Risc.message_reg
      slot = left_slots.shift
      while( !left_slots.empty? )
        left = left.resolve_and_add( slot , compiler)
        slot = left_slots.shift
      end
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slot)
    end

  end
end
