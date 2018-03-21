module Mom

  # Unconditional jump to the Label given
  # Eg used at the end of while or end of if_true branch
  #
  # Risc equivalent is the same really, called Unconditional there.
  #
  class Jump < Instruction
    attr_reader :label

    def initialize(label)
      @label = label
    end
    def to_risc(compiler)
      Risc::Unconditional.new(self , @label.to_risc(compiler))
    end
  end


end
