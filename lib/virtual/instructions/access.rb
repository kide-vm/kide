module Virtual

  # class for Set instructions, A set is basically a mem move.
  # to and from are indexes into the known objects(frame,message,self and new_message), these are represented as slots
  # (see there) 
  # from may be a Constant (Object,Integer,String,Class)
  class Set < Instruction
    def initialize to , from
      @to = to
      # hard to find afterwards where it came from, so ensure it doesn't happen
      raise "From must be slot or constant, not symbol #{from}" if from.is_a? Symbol
      @from = from
    end
    attr_reader :to , :from
  end

  # Get a instance variable by _name_ . So we have to resolve the name to an index to trnsform into a Slot
  # The slot may the be used in a set on left or right hand. The transformation is done by GetImplementation
  class InstanceGet < Instruction
    def initialize name
      @name = name.to_sym
    end
    attr_reader :name
  end
end
