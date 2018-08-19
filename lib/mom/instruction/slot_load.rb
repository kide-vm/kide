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
  # original_source: optinally another mom instruction that wil be passed down to created
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
      #puts "RISC #{self}"
      const_reg = @right.to_register(compiler , original_source)
      left_slots = @left.slots
      case @left.known_object
      when Symbol
        sym_to_risc(compiler , const_reg)
      when Parfait::CacheEntry
        left = compiler.use_reg( :CacheEntry )
        compiler.add_code Risc.load_constant(original_source, @left.known_object , left)
        compiler.add_code Risc.reg_to_slot(original_source, const.register , left, left_slots.first)
      else
        raise "We have left #{@left.known_object}"
      end
      compiler.reset_regs
    end

    def sym_to_risc(compiler , const_reg)
      left_slots = @left.slots.dup
      raise "Not Message #{object}" unless @left.known_object == :message
      left = Risc.message_reg
      slot = left_slots.shift
      while( !left_slots.empty? )
        left = left.resolve_and_add( slot , compiler)
        slot = left_slots.shift
      end
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slot)
    end

  end

end
require_relative "slot_definition"
