module Register


  # a branch must branch to a block.
  class Branch < Instruction
    def initialize source , to
      super(source)
      @label = to
    end
    attr_reader :label

    def to_s
      "#{self.class.name}: #{label.name}"
    end
    alias :inspect :to_s

    def length labels = []
      ret = super(labels)
      ret += self.label.length(labels) if self.label
      ret
    end

    def to_ac labels = []
      ret = super(labels)
      ret += self.label.to_ac(labels) if self.label
      ret
    end

    def total_byte_length labels = []
      ret = super(labels)
      ret += self.label.total_byte_length(labels) if self.label
      #puts "#{self.class.name} return #{ret}"
      ret
    end

    # labels have the same position as their next
    def set_position position , labels = []
      position = self.label.set_position( position , labels ) if self.label
      super(position,labels)
    end

    def assemble_all io , labels = []
      self.assemble(io)
      self.label.assemble_all(io,labels) if self.label
      self.next.assemble_all(io, labels) if self.next
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
