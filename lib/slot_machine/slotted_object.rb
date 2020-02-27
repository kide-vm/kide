module SlotMachine
  class SlottedObject < Slotted

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
      type = known_object.get_type
      raise "not sym for #{known_object}" if type.is_a?(String)
      right = compiler.use_reg( type )
      const = Risc.load_constant(source, known_object , right)
      compiler.add_code const
      if slots_length > 1
        # desctructively replace the existing value to be loaded if more slots
        compiler.add_code Risc.slot_to_reg( source , right ,slots.name, right)
      end
      if slots_length > 2
        # desctructively replace the existing value to be loaded if more slots
        index = Risc.resolve_to_index(slots.name , slots.next_slot.name ,compiler)
        compiler.add_code Risc::SlotToReg.new( source , right ,index, right)
        if slots_length > 3
          raise "3 slots only for type #{slots}" unless slots.next_slot.next_slot.name == :type
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
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slots.name)
    end
  end
end
