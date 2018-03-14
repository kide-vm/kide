module Risc

  # Getter is a base class for get instructions (SlotToReg and ByteToReg , possibly more coming)
  #
  # The instruction that is modelled is loading data from an array into a register
  #
  # Getter has a
  # - an array where the data comes from
  # - an (array) index
  # - Register that the data is moved to

  # Getter and Setter api follow the pattern from -> to

  class Getter < Instruction

    # If you had a c array and index offset
    # the instruction would do register = array[index]
    # The arguments are in the order that makes sense for the Instruction name
    # So SlotToReg means the slot (array and index) moves to the register (last argument)
    def initialize( source , array , index , register )
      super(source)
      @array = array
      @index = index
      @register = register
      raise "index 0 " if index == 0
      raise "Not integer or reg #{index}" unless index.is_a?(Numeric) or RiscValue.look_like_reg(index)
      raise "Not register #{register}" unless RiscValue.look_like_reg(register)
      raise "Not register #{array}" unless RiscValue.look_like_reg(array)
    end
    attr_accessor :array , :index , :register

    def to_s
      "#{self.class.name.split("::").last}: #{array}[#{index}] -> #{register}"
    end

  end

end
