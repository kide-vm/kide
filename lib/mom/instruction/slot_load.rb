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

    def to_risc(compiler)
      const = @right.to_register(compiler , original_source)
      left_slots = @left.slots
      case @left.known_object
      when Symbol
        left = Risc.message_reg
        left_index = Risc.resolve_to_index(@left.known_object , left_slots.first)
        if left_slots.length > 1
          # swap the existing target (with a new reg) and update the index
          new_left = compiler.use_reg( :int )
          const << Risc::SlotToReg.new( original_source , left ,left_index, new_left)
          left = new_left
          left_index = SlotLoad.resolve_to_index(left_slots[0] , left_slots[1] ,compiler)
          if left_slots.length > 2
            #same again, once more updating target
            new_left = compiler.use_reg( :int )
            const << Risc::SlotToReg.new( original_source , left ,left_index, new_left)
            left = new_left
            left_index = SlotLoad.resolve_to_index(left_slots[1] , left_slots[2] ,compiler)
          end
          raise "more slots not implemented #{left_slots}" if left_slots.length > 3
        end
      when Parfait::CacheEntry
        left = compiler.use_reg( :int )
        const << Risc.load_constant(original_source, @left.known_object , left)
        left_index = Risc.resolve_to_index(:cache_entry , left_slots.first)
      else
        raise "We have left #{@left.known_object}"
      end
      const << Risc.reg_to_slot(original_source, const.register , left, left_index)
      compiler.reset_regs
      return const
    end

    def self.resolve_to_index(object , variable_name ,compiler)
      return variable_name if variable_name.is_a?(Integer)
      case object
      when :frame
        type = compiler.method.frame
      when :message , :next_message , :caller
        type = Parfait.object_space.get_class_by_name(:Message).instance_type
      when :arguments
        type = compiler.method.arguments
      when :receiver
        type = compiler.method.for_type
      when Parfait::Object
        type = Parfait.object_space.get_class_by_name( object.class.name.split("::").last.to_sym).instance_type
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
    #        Examples:  [:message , :receiver] or [:Space , :next_message]
    def initialize( object , slots)
      @known_object , @slots = object , slots
      slot = [slot] unless slot.is_a?(Array)
      raise "Not known #{slots}" unless object
      raise "No slots #{object}" unless slots
    end

    def to_register(compiler, instruction)
      type = known_object.respond_to?(:ct_type) ? known_object.ct_type : :int
      right = compiler.use_reg( type )
      case known_object
      when Constant
        parfait = known_object.to_parfait(compiler)
        const  = Risc.load_constant(instruction, parfait , right)
        raise "Can't have slots into Constants" if slots.length > 0
      when Parfait::Object , Risc::Label
        const  = Risc.load_constant(instruction, known_object , right)
        if slots.length > 0
          # desctructively replace the existing value to be loaded if more slots
          index = SlotLoad.resolve_to_index(known_object , slots[0] ,compiler)
          const << Risc::SlotToReg.new( instruction , right ,index, right)
        end
      when Symbol
        const = Risc::SlotToReg.new( instruction , Risc.resolve_to_register(known_object) ,
                              Risc.resolve_to_index(:message , slots[0]), right)
      else
        raise "We have a #{self} #{known_object}"
      end
      if slots.length > 1
        # desctructively replace the existing value to be loaded if more slots
        index = SlotLoad.resolve_to_index(slots[0] , slots[1] ,compiler)
        const << Risc::SlotToReg.new( instruction , right ,index, right)
        raise "more slots not implemented #{slots}" if slots.length > 2
      end
      const
    end
  end
end
