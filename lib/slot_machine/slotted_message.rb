module SlotMachine
  class SlottedMessage < Slotted

    def known_name
      :message
    end
    alias :known_object :known_name

    def initialize(slots)
      super(slots)
      raise "Message must have slots, but none given" unless slots
    end
    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      left = Risc.message_named_reg
      slots = @slots
      while( slots )
        left = left.resolve_and_add( slots.name , compiler)
        slots = slots.next_slot
      end
      return left
    end

    # load the data in const_reg into the slot that is named by slot symbols
    # actual lifting is done by RegisterValue resolve_and_add
    #
    # Note: this is the left hand case, the right hand being to_register
    #       They are very similar (apart from the final reg_to_slot here) and should
    #       most likely be united
    def reduce_and_load(const_reg , compiler , original_source )
      left = Risc.message_named_reg
      slot = slots
      while( slot.next_slot )
        left = left.resolve_and_add( slot.name , compiler)
        slot = slot.next_slot
      end
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slot.name)
    end

  end
end
