module Register


  # a branch must branch to a block.
  class Branch < Instruction
    def initialize source , to
      super(source)
      raise "No block" unless to
      @label = to
    end
    attr_reader :label

    def to_s
      "#{self.class.name}: #{label.name}"
    end
    alias :inspect :to_s

    def length labels = []
      super(labels) + self.label.length(labels)
    end

    def to_ac labels = []
      super(labels) + self.label.to_ac(labels)
    end
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
