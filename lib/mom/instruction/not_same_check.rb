module Mom

  # Mom internal check, as the name says to see if two values are not the same
  # In other words, we this checks identity, bit-values, pointers
  #
  # The values that are compared are defined as SlotDefinitions, ie can be anything
  # available to the machine through frame message or self
  #
  class NotSameCheck < Check
    attr_reader :left , :right

    def initialize(left, right)
      @left , @right  = left , right
    end

    def to_risc(context)
      Risc::Label.new(self,"NotSameCheck")
    end
  end
end
