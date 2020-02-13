module SlotLanguage
  # A Variable makes Slots. A Slot is the central SlotMachines description of a
  # variable in an object. At the Language level this holds the information
  # (names of instance variables) to be able to create the Slot instance
  #
  # In the SlotLanguage this is used in the Assignment. Just as a Slotload stores
  # two slots to define what is loaded where, the Assignment, that creates a SlotLoad,
  # uses two Variables.
  class Variable
    # stores the (instance) names that allow us to create a Slot
    attr_reader :names

    def initialize(names)
      case names
      when Array
        @names = names
      when nil
        raise "No names given"
      else
        @names = [names]
      end
    end

    def add_slot_name(name)
      @names << name
    end

    def to_slot(compiler)
      SlotMachine::Slot.for(:message , names)
    end

    def to_s
      "message." + names.join(",")
    end
  end
end
