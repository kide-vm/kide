module Register
  # Setter is a base class for set instructions (SetSlot and SetByte , possibly more coming)
  #
  # The instruction that is modelled is loading data from an array into a register
  #
  # Setter has a
  # - Register that the data is moved to
  # - an array where the data comes from
  # - and (array) index
  class Setter < Instruction

    # If you had a c array and index offset
    # the instruction would do array[index] = register
    # So Setter means the register (first argument) moves to the slot (array and index)
    def initialize source , register , array , index
      super(source)
      @register = register
      @array = array
      @index = index
      raise "index 0 " if index == 0
      raise "Not integer or reg #{index}" unless index.is_a?(Numeric) or RegisterValue.look_like_reg(index)
      raise "Not register #{register}" unless RegisterValue.look_like_reg(register)
      raise "Not register #{array}" unless RegisterValue.look_like_reg(array)
    end
    attr_accessor :register , :array , :index

  end

end
