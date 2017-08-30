module Mom

  # unconditional jump to the instruction given as target
  # 
  class Jump < Instruction
    attr_reader :target

    def initialize(target)
      @target = target
    end
  end


end
