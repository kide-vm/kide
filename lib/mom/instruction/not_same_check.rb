module Mom

  # Mom internal check, as the name says to see if two values are not the same
  # In other words, we this checks identity, bit-values, pointers
  #
  # The values that are compared are defined as SlotDefinitions, ie can be anything
  # available to the machine through frame message or self
  #
  # Acording to Mom::Check logic, we jump to the given label is the values are the same
  #
  class NotSameCheck < Check
    attr_reader :left , :right

    def initialize(left, right , label)
      super(label)
      @left , @right  = left , right
    end

    def to_s
      "NotSameCheck: #{left}:#{right}"
    end

    # basically move both left and right values into register
    # subtract them and see if IsZero comparison
    def to_risc(compiler)
      l_val = left.to_register(compiler, self)
      r_val = right.to_register(compiler, self)
      check = Risc.op( self , :- , l_val.register , r_val.register)
      check << Risc::IsZero.new( self, false_jump.to_risc(compiler))
      l_val << r_val << check
    end
  end
end
