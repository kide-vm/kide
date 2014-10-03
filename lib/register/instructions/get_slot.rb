module Register
  # offset memory get access
  # so the value to be set must be given as the first register
  # the second argument holds the base address
  # and the third a possible (small) offset into the "object"
  #
  # if for example the value is pointed to by a register, a VariableGet (load) is needed first
  class GetSlot < Instruction
    def initialize value , reference , index = 0
      @value = value
      @reference = reference
      @index = index
    end
    attr_accessor :value , :reference , :index
  end
end
