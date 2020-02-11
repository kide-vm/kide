module SlotMachine
  class ObjectDefinition < SlotDefinition

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

    # Note: this is the left hand case, the right hand being to_register
    #       They are very similar (apart from the final reg_to_slot here) and should
    #       most likely be united
    def reduce_and_load(const_reg , compiler , original_source )
      raise "only cache" unless known_object.is_a?( Parfait::CacheEntry)
      left = compiler.use_reg( :CacheEntry )
      compiler.add_code Risc.load_constant(original_source, known_object , left)
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slots.first)
    end
  end
end
