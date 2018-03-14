module Mom
  # A SlotConstant moves a constant into a known Slot.
  # Eg when you write a = 5 , the 5 becomes a constant, and so the right side
  # the a is an instance variable on the current frame, and the frame is an instance
  # of the current message, so the effect is something like message.frame.a = 5
  # @left:  See SlotLoad, an array of symbols
  # @right: A Constant from parse, ie an instance of classes in basc_value, like TrueStatement
  class SlotConstant < SlotLoad

    def initialize(left , right)
      super
      raise "right not constant, #{right}" unless right.is_a? Mom::Constant
    end

    def to_risc(context)
      reg = context.use_reg( @right.ct_type)
      const  = Risc.load_constant(self, @right , reg)
      const.set_next Risc.reg_to_slot(self, reg , @left.known_object, @left.slots.first)
      context.release_reg(reg)
      return const
    end

  end

end
