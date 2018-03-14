module Mom

  # unconditional jump to the instruction given as target
  #
  class Jump < Instruction
    attr_reader :target

    def initialize(target)
      @target = target
    end
    def to_risc(context)
      Risc::Label.new(self,"Jump")
    end
  end


end
