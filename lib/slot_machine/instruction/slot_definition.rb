module SlotMachine
  # A SlotDefinition defines a slot. A bit like a variable name but for objects.
  #
  # PS: for the interested: A "development" of Smalltalk was the
  #     prototype based language (read: JavaScript equivalent)
  #     called Self https://en.wikipedia.org/wiki/Self_(programming_language)
  #
  # SlotDefinitions are the instance names of objects. But since the language is dynamic
  # what is it that we can say about instance names at runtime?
  # Start with a known object like the Message (in register one), we know all it's
  # variables. But there is a Message in there, and for that we know the instances
  # too. And off course for _all_ objects we know where the type is.
  #
  # The definiion is an array of symbols that we can resolve to SlotLoad
  # Instructions. Or in the case of constants to ConstantLoad
  #
  class SlotDefinition
    # get the right definition, depending on the object
    def self.for(object , slots)
      case object
      when :message
        MessageDefinition.new(slots)
      when Constant
        ConstantDefinition.new(object , slots)
      else
        SlotDefinition.new(object,slots)
      end
    end

    attr_reader :known_object , :slots
    # is an array of symbols, that specifies the first the object, and then the Slot.
    # The first element is either a known type name (Capitalized symbol of the class name) ,
    # or the symbol :message
    # And subsequent symbols must be instance variables on the previous type.
    # Examples:  [:message , :receiver] or [:Space , :next_message]
    def initialize( object , slots)
      raise "No slots #{object}" unless slots
      slots = [slots] unless slots.is_a?(Array)
      @known_object , @slots = object , slots
      raise "Not known #{slots}" unless object
    end

    def to_s
      names = [known_name] + @slots
      "[#{names.join(', ')}]"
    end

    def known_name
      case known_object
      when Parfait::Object
        known_object.class.short_name
      when Risc::Label
        known_object.to_s
      else
        "unknown"
      end
    end

    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      if(known_object.respond_to?(:get_type))
        type = known_object.get_type
      else
        type = :Object
      end
      right = compiler.use_reg( type )
      case known_object
      when Parfait::Object , Risc::Label
        const = Risc.load_constant(source, known_object , right)
        compiler.add_code const
        if slots.length > 0
          # desctructively replace the existing value to be loaded if more slots
          compiler.add_code Risc.slot_to_reg( source , right ,slots[0], right)
        end
      else
        raise "We have a #{self} #{known_object}"
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

  end
end
