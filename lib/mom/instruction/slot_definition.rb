module Mom
  # A SlotDefinition defines a slot. A bit like a variable name but for objects.
  #
  # PS: for the interested: A "developement" of Smalltalk was the
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
      "[#{names.join(',')}]"
    end

    def known_name
      case known_object
      when Constant , Parfait::Object
        known_object.class.short_name
      when Risc::Label
        known_object.to_s
      when Symbol
        known_object
      else
        "unknown"
      end
    end
    def to_register(compiler, instruction)
      type = known_object.respond_to?(:ct_type) ? known_object.ct_type : :Object
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
          index = Risc.resolve_to_index(known_object , slots[0] ,compiler)
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
        index = Risc.resolve_to_index(slots[0] , slots[1] ,compiler)
        const << Risc::SlotToReg.new( instruction , right ,index, right)
        if slots.length > 2
          raise "3 slots only for type #{slots}" unless slots[2] == :type
          const << Risc::SlotToReg.new( instruction , right , 0, right)
        end
      end
      const
    end
  end
end
