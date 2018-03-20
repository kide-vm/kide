module Mom

  # Unconditional jump to the Label given as target
  # Eg used at the end of while or end of if_true branch
  #
  # Risc equivalent is the same really, called Unconditional there.
  #
  class Jump < Instruction
    attr_reader :target

    def initialize(target)
      @target = target
    end
    def to_risc(compiler)
      Risc::Unconditional.new(self , @target.to_risc(compiler))
    end
  end


end
