module Mom

  # SlotLoad is for moving data into a slot, either from another slot, or constant
  # A Slot is basically an instance variable, but it must be of known type
  #
  # The value loaded (the right hand side) can be a constant (Mom::Constant) or come from
  #  another Slot (SlotDefinition)
  #
  # The Slot on the left hand side is always a SlotDefinition.
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
  # @left: A SlotDefinition, or an array that can be passed to the constructor of the
  #        SlotDefinition (see there)
  #
  # @right: A SlotDefinition with slots or a Mom::Constant
  # original_source: optinally another mom instrucion that wil be passed down to created
  #   risc instructions. (Because SlotLoad is often used internally in mom)
  class SlotLoad < Instruction
    attr_reader :left , :right , :original_source
    def initialize(left , right, original_source = nil)
      @left , @right = left , right
      @left = SlotDefinition.new(@left.shift , @left) if @left.is_a? Array
      @right = SlotDefinition.new(@right.shift , @right) if @right.is_a? Array
      raise "right not Mom, #{@right.to_s}" unless @right.is_a?( SlotDefinition )
      @original_source = original_source || self
    end

    def to_s
      "SlotLoad #{right} -> #{left}"
    end

    def to_risc(compiler)
      const = @right.to_register(compiler , original_source)
      left_slots = @left.slots
      case @left.known_object
      when Symbol
        left = Risc.message_reg
        left_index = Risc.resolve_to_index(@left.known_object , left_slots.first)
        if left_slots.length > 1
          # swap the existing target (with a new reg) and update the index
          new_left = compiler.use_reg( :Object )
          const << Risc::SlotToReg.new( original_source , left ,left_index, new_left)
          left = new_left
          left_index = Risc.resolve_to_index(left_slots[0] , left_slots[1] ,compiler)
          if left_slots.length > 2
            #same again, once more updating target
            new_left = compiler.use_reg( :Object )
            const << Risc::SlotToReg.new( original_source , left ,left_index, new_left)
            left = new_left
            left_index = Risc.resolve_to_index(left_slots[1] , left_slots[2] ,compiler)
          end
          raise "more slots not implemented #{left_slots}" if left_slots.length > 3
        end
      when Parfait::CacheEntry
        left = compiler.use_reg( :Object )
        const << Risc.load_constant(original_source, @left.known_object , left)
        left_index = Risc.resolve_to_index(:cache_entry , left_slots.first)
      else
        raise "We have left #{@left.known_object}"
      end
      const << Risc.reg_to_slot(original_source, const.register , left, left_index)
      compiler.reset_regs
      return const
    end
  end

end
require_relative "slot_definition"
