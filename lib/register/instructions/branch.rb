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
      "#{self.class.name}: #{block.name}"
    end
    alias :inspect :to_s
  end

  class IsZero < Branch
  end

  class IsNotzero < Branch
  end

  class IsMinus < Branch
  end

  class IsPlus < Branch
  end

end
