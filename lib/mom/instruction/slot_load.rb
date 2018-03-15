module Mom

  # SlotLoad is an abstract base class for moving data into a slot
  # A Slot is basically an instance variable, but it must be of known type
  #
  # The value loaded (the right hand side) can be a constant (Mom::Constant) or come from
  #  another Slot (SlotDefinition)
  #
  # The Slot on the left hand side is always a SlotDefinition.
  # The only known object (*) for the left side is the current message, which is a bit like
  # the oo version of a PC (program Counter)
  # (* off course all class objects are global, and so they are allowed too)
  #
  # A maybe not immediately obvious corrolar of this design is the total absence of
  # general purpose instance variable accessors. Ie only inside an object's functions
  # can a method access instance variables, because only inside the method is the type
  # guaranteed.
  # From the outside a send is neccessary, both for get and set, (which goes through the method
  # resolution and guarantees the correct method for a type), in other words perfect data hiding.
  #
  # @left: A SlotDefinition, or an array that can be passed to the constructor of the
  #        SlotDefinition (see there)
  #
  # @right: Either a SlotDefinition or a Constant
  #
  class SlotLoad < Instruction
    attr_reader :left , :right
    def initialize(left , right)
      left = SlotDefinition.new(left.shift , left) if left.is_a? Array
      right = SlotDefinition.new(right.shift , right) if right.is_a? Array
      raise "right not Mom, #{right.to_s}" unless right.is_a?( SlotDefinition )or right.is_a? Mom::Constant
      @left , @right = left , right
    end

    def to_risc_load(context)
      reg = context.use_reg( @right.ct_type)
      const  = Risc.load_constant(self, @right , reg)
      const.set_next Risc.reg_to_slot(self, reg , @left.known_object, @left.slots.first)
      context.release_reg(reg)
      return const
    end

    def to_risc_move(context)
      reg = context.use_reg(:int)#( @right.ct_type)
      const  = Risc.load_constant(self, @right , reg)
#      const.set_next Risc.reg_to_slot(self, reg , @left.known_object, @left.slots.first)
#      context.release_reg(reg)
      return const
    end


  end

  class SlotDefinition
    attr_reader :known_object , :slots
    #         is an array of symbols, that specifies the first the object, and then the Slot.
    #        The first element is either a known type name (Capitalized symbol of the class name) ,
    #        or the symbol :message
    #        And subsequent symbols must be instance variables on the previous type.
    #        Examples:  [:message , :receiver] or [:Space : :next_message]
    def initialize( object , slots)
      @known_object , @slots = object , slots
      slot = [slot] unless slot.is_a?(Array)
    end
  end
end
