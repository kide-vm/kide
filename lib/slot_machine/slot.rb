module SlotMachine
  # A Slot defines a slot in a slotted. A bit like a variable name but for objects.
  #
  # PS: for the interested: A "development" of Smalltalk was the
  #     prototype based language (read: JavaScript equivalent)
  #     called Self https://en.wikipedia.org/wiki/Self_(programming_language)
  #
  # Slots are the instance names of objects. But since the language is dynamic
  # what is it that we can say about instance names at runtime?
  # Start with a Slotted, like the Message (in register one), we know all it's
  # variables. But there is a Message in there, and for that we know the instances
  # too. And off course for _all_ objects we know where the type is.
  #
  # The definiion is an array of symbols that we can resolve to SlotLoad
  # Instructions. Or in the case of constants to ConstantLoad
  #
  class Slot

    attr_reader :name , :next_slot

    # initialize with just the name of the slot. Add more to the chain with set_next
    def initialize( name )
      raise "No name" unless name
      @name = name
    end

    #set the next_slot , but always at the end of the chain
    def set_next(slot)
      if(@next_slot)
        @next_slot.set_next(slot)
      else
        @next_slot = slot
      end
    end

    # return the length of chain, ie 1 plus however many more next_slots there are
    def length
      return 1 unless @next_slot
      1 + @next_slot.length
    end

    # name of all the slots, with dot syntax
    def to_s
      names = name.to_s
      names += ".#{@next_slot}" if @next_slot
      names
    end

  end
end
