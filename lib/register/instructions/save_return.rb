module Register

  # save the return address of a call
  # register and index specify where the return address is stored

  class SaveReturn < Instruction
    def initialize register , index
      @register = register
      @index = index
    end
    attr_reader :register , :index
  end
end