module Register


  # a branch must branch to a block.
  class Branch < Instruction
    def initialize source , to
      super(source)
      raise "No block" unless to
      @block = to
    end
    attr_reader :block

    def to_s
      "Branch: #{block.name}"
    end
    alias :inspect :to_s 
  end

  class IsZeroBranch < Branch
  end

  class IsNegativeBranch < Branch
  end

  class IsPositiveBranch < Branch
  end

  class AlwaysBranch < Branch
  end

end
