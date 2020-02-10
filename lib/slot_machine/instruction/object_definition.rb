module SlotMachine
  class ObjectDefinition < SlotDefinition

    # get the right definition, depending on the object
    def self.for(object , slots)
      case object
      when :message
        MessageDefinition.new(slots)
      when Constant
        ConstantDefinition.new(object , slots)
      when Parfait::Object
        ObjectDefinition.new(object , slots)
      else
        SlotDefinition.new(object,slots)
      end
    end

    def initialize( object , slots)
      super(object , slots )
    end

    def known_name
      known_object.class.short_name
    end

    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      type = known_object.get_type
      right = compiler.use_reg( type )
      const = Risc.load_constant(source, known_object , right)
      compiler.add_code const
      if slots.length > 0
        # desctructively replace the existing value to be loaded if more slots
        compiler.add_code Risc.slot_to_reg( source , right ,slots[0], right)
      end
      if slots.length > 1
        # desctructively replace the existing value to be loaded if more slots
        index = Risc.resolve_to_index(slots[0] , slots[1] ,compiler)
        compiler.add_code Risc::SlotToReg.new( source , right ,index, right)
        if slots.length > 2
          raise "3 slots only for type #{slots}" unless slots[2] == :type
          compiler.add_code Risc::SlotToReg.new( source , right , Parfait::TYPE_INDEX, right)
        end
      end
      return const.register
    end

  end
end
