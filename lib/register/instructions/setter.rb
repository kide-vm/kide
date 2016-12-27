module Register
  # Setter is a base class for set instructions (RegToSlot and RegToByte , possibly more coming)
  #
  # The instruction that is modelled is loading data from a register into an array
  #
  # Setter has a
  # - Register that the data is comes from
  # - an array where the data goes
  # - and (array) index

  # Getter and Setter api follow the pattern from -> to

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

    def to_s
      "#{self.class.name}: #{register} -> #{array}[#{index}]"
    end

  end

end
