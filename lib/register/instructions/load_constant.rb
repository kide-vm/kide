module Register
  # load a constant into a register
  #
  # first is the actual constant, either immediate register or object reference (from the space)
  # second argument is the register the constant is loaded into

  class LoadConstant < Instruction
    def initialize constant , register
      @register = register
      @constant = constant
    end
    attr_accessor :register , :constant
  end
end
