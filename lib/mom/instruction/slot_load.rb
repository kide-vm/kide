module Mom

  # SlotLoad is an abstract base class for moving data into a slot
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
      raise "right not Mom, #{right.to_s}" unless right.is_a?( SlotDefinition )#or right.is_a? Mom::Constant
      @left , @right = left , right
    end

    def to_risc(compiler)
      type = @right.respond_to?(:ct_type) ? @right.ct_type : :int
      right = compiler.use_reg( type )
      case @right.known_object
      when Constant
        const  = Risc.load_constant(self, @right , right)
      when Symbol
        const = Risc::SlotToReg.new( self , Risc.resolve_to_register(@right.known_object) ,
                              Risc.resolve_to_index(:message , @right.slots[0]), right)
        if @right.slots.length > 1
          # desctructively replace the existing value to be loaded if more slots
          index = resolve_to_index(@right.slots[0] , @right.slots[1] ,compiler)
          const << Risc::SlotToReg.new( self , right ,index, right)
          raise "more slots not implemented #{@right.slots}" if @right.slots.length > 2
        end
      else
        raise "We have a #{@right} #{@right.known_object}"
      end
      case @left.known_object
      when Symbol
        left = Risc.message_reg
        left_index = Risc.resolve_to_index(@left.known_object , @left.slots.first)
      when Parfait::CacheEntry
        left = compiler.use_reg( :int )
        left_index = Risc.resolve_to_index(:cache_entry , @left.slots.first)
      else
        raise "We have left #{@left.known_object}"
      end
      const << Risc.reg_to_slot(self, right , left, left_index)
      compiler.release_reg(left) unless @left.known_object.is_a?(Symbol)
      compiler.release_reg(right)
      return const
    end

    def resolve_to_index(object , variable_name ,compiler)
      case object
      when :frame
        type = compiler.method.frame
      when :arguments
        type = compiler.method.arguments
      when :receiver
        type = compiler.method.for_type
      else
        raise "Not implemented/found object #{object}"
      end
      index = type.variable_index(variable_name)
      raise "Index not found for #{variable_name} in #{object} of type #{type}" unless index
      return index
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
      raise "Not known #{slots}" unless object
    end
  end
end
