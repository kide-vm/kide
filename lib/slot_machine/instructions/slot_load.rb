module SlotMachine

  # SlotLoad is for moving data into a slot, either from another slot, or constant
  # A Slot is basically an instance variable, but it must be of known type
  #
  # The value loaded (the right hand side) can be a constant (SlotMachine::Constant) or come from
  #  another Slot (Slot)
  #
  # The Slot on the left hand side is always a Slot.
  # The only known object (*) for the left side is the current message, which is a bit like
  # the oo version of a Stack (Stack Register, Frame Pointer, ..)
  # (* off course all class objects are global, and so they are allowed too)
  #
  # A maybe not immediately obvious corrolar of this design is the total absence of
  # general external instance variable accessors. Ie only inside an object's functions
  # can a method access instance variables, because only inside the method is the type
  # guaranteed.
  # From the outside a send is neccessary, both for get and set, (which goes through the method
  # resolution and guarantees the correct method for a type), in other words perfect data hiding.
  #
  # @left: A Slot, or an array that can be passed to the constructor of the
  #        Slot (see there)
  #
  # @right: A Slot with slots or a SlotMachine::Constant
  # original_source: optinally another slot_machine instruction that will be passed down
  #                to created  risc instructions. (Because SlotLoad is often used internally)
  class SlotLoad < Instruction

    attr_reader :left , :right , :original_source

    def initialize(source , left , right, original_source = nil)
      super(source)
      @left , @right = left , right
      @left = Slotted.for(@left.shift , @left) if @left.is_a? Array
      @right = Slotted.for(@right.shift , @right) if @right.is_a? Array
      raise "right not SlotMachine, #{@right.to_s}" unless @right.is_a?( Slotted )
      raise "left not SlotMachine, #{@left.to_s}" unless @left.is_a?( Slotted )
      @original_source = original_source || self
    end

    def to_s
      "SlotLoad #{right} -> #{left}"
    end

    # resolve the SlotLoad to the respective risc Instructions.
    # calls sym_to_risc for most (symbols), and ConstantLoad for CacheEntry
    # after loading the right into register
    def to_risc(compiler)
      const_reg = @right.to_register(compiler , original_source)
      @left.reduce_and_load(const_reg , compiler , original_source )
    end

  end

end
