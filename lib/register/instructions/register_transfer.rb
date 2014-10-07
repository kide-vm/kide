module Register

  #transfer the constents of one register to another. possibly called move in some cpus

  class RegisterTransfer < Instruction
    def initialize from , to
      @from = wrap_register(from)
      @to = wrap_register(to)
    end
    attr_reader :from, :to
  end
end