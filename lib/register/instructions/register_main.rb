module Register

  # This starts the register machine machine at the given function.
  
  # The implementation is most likely a jump/branch , but since we have the extra layer
  # we make good use of it, ie give things descriptive names (what they do, not how)

  class RegisterMain < Instruction
    def initialize method
      @method = method
    end
    attr_reader :method
  end
end