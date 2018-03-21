module Mom

  # Mom internal check, as the name says to see if two values are not the same
  # In other words, we this checks identity, bit-values, pointers
  #
  # The values that are compared are defined as SlotDefinitions, ie can be anything
  # available to the machine through frame message or self
  #
  class NotSameCheck < Check
    attr_reader :left , :right

    def initialize(left, right , label)
      super(label)
      @left , @right  = left , right
    end

    # basically move both left and right values into register and issue a
    # risc comparison
    def to_risc(compiler)
      l_val = left.to_register(compiler, self)
      r_val = right.to_register(compiler, self)
      check = Risc::NotSame.new(self, l_val.register, r_val.register, false_jump.to_risc(compiler))
      l_val << r_val << check
    end
  end
end
