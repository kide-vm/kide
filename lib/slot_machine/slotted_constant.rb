module SlotMachine
  class SlottedConstant < Slotted

    attr_reader :known_object

    def initialize( object , slots)
      super(slots)
      @known_object = object
      raise "Not known #{slots}" unless object
    end

    def known_name
      known_object.class.short_name
    end

    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      if known_object.respond_to?(:ct_type)
        type = known_object.ct_type
      else
        type = :Object
      end
      parfait = known_object.to_parfait(compiler)
      last = Risc.load_constant(source, parfait )
      compiler.add_code(last)
      if slots_length == 2
        raise "only type allowed for constants, not #{slots}" unless slots.name == :type
        last = Risc.slot_to_reg( source , last.register , Parfait::TYPE_INDEX )
        compiler.add_code(last)
      end
      raise "Can't have slots into Constants #{slots}" if slots_length > 2
      return last.register
    end

  end
end
