module SlotLanguage
  # A Variable makes Slots. A Slot is the central SlotMachines description of a
  # variable in an object. At the Language level this holds the information
  # (names of variables) to be able to create the Slot instance
  #
  # In the SlotLanguage this is used in the Assignment. Just as a Slotload stores
  # two slots to define what is loaded where, the Assignment, that creates a SlotLoad,
  # uses two Variables.
  class Variable
    # stores the (instance) names that allow us to create a Slot
    attr_reader :name , :chain

    def initialize(name)
      @name = name
      raise "No name given #{name}" unless name.is_a?(Symbol)
    end

    def chained(to)
      raise "Must chain to variable #{to}" unless to.is_a?(Variable)
      if(@chain)
        @chain.chained(to)
      else
        @chain = to
      end
      self
    end

    def to_slot(compiler)
      SlotMachine::Slot.for(:message , name)
    end

    def to_s
      str = "message.#{name}"
      str += chain.to_s if @chain
      str
    end
  end

  class MessageVariable < Variable
  end
  class Constant < Variable
  end
end
