module SlotMachine
  class SlottedConstant < Slot


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
      right = compiler.use_reg( type )
      parfait = known_object.to_parfait(compiler)
      const = Risc.load_constant(source, parfait , right)
      compiler.add_code const
      if slots.length == 1
        raise "only type allowed for constants, not #{slots[0]}" unless slots[0] == :type
        compiler.add_code Risc::SlotToReg.new( source , right , Parfait::TYPE_INDEX, right)
      end
      raise "Can't have slots into Constants #{slots}" if slots.length > 1
      return const.register
    end

  end
end
