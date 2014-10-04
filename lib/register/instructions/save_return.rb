module Register

  # save the return address of a call
  # register and index specify where the return address is stored

  # This instruction exists mainly, so we don't have to hard-code where the machine stores the 
  # address. In arm that is a register, but intel may (?) push it, and who knows, what other machines do.

  class SaveReturn < Instruction
    def initialize register , index
      @register = register
      @index = index
    end
    attr_reader :register , :index
  end
end