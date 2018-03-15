module Mom

  #SlotMove is a SlotLoad where the right side is a slot, just like the left.
  class SlotMove < SlotLoad

    def initialize(left , right)
      right = SlotDefinition.new(right.shift , right) if right.is_a? Array
      raise "right not Mom, #{right.to_s}" unless right.is_a?( SlotDefinition )
      super(left , right)
    end

    def to_risc(context)
      reg = context.use_reg(:int)#( @right.ct_type)
      const  = Risc.load_constant(self, @right , reg)
#      const.set_next Risc.reg_to_slot(self, reg , @left.known_object, @left.slots.first)
#      context.release_reg(reg)
      return const
    end

  end
end
