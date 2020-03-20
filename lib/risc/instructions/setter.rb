module Risc
  # Setter is a base class for set instructions (RegToSlot and RegToByte , possibly more coming)
  #
  # The instruction that is modelled is loading data from a register into an array
  #
  # Setter has a
  # - Risc that the data is comes from
  # - an array where the data goes
  # - and (array) index

  # Getter and Setter api follow the pattern from -> to

  class Setter < Instruction

    # If you had a c array and index offset
    # the instruction would do array[index] = register
    # The arguments are in the order that makes sense for the Instruction name
    # So RegToSlot means the register (first argument) moves to the slot (array and index)
    def initialize( source , register , array , index )
      super(source)
      @register = register
      @array = array
      @index = index
      raise "Not integer or reg index #{index}" unless index.is_a?(Numeric) or RegisterValue.look_like_reg(index)
      raise "Not register #{register}" unless RegisterValue.look_like_reg(register)
      raise "Not slot/register #{array}" unless RegisterValue.look_like_reg(array)
    end
    attr_accessor :register , :array , :index

    # return an array of names of registers that is used by the instruction
    def register_attributes
      names = [:array , :register]
      names << :index if index.is_a?(RegisterValue)
      names
    end

    def to_s
      class_source "#{register} -> #{array}[#{index}]"
    end

  end

end
