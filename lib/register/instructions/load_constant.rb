module Register
  # load a constant into a register
  #
  # first argument is the register the constant is loaded into
  # second is the actual constant

  class LoadConstant < Instruction
    def initialize value , constant
      @value = value
      @constant = constant
    end
    attr_accessor :value , :constant
  end
end
