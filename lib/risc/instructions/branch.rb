module Risc

  # A branch must branch to a label.
  # Different Branches (derived classes) use different registers, the base
  # just stores the Label
  class Branch < Instruction
    def initialize( source , label )
      super(source)
      raise "not label #{label}:#{label.class}" unless label.is_a?(Label) or label.is_a?(Parfait::BinaryCode)
      @label = label
    end
    attr_reader :label

    # return an array of names of registers that is used by the instruction
    def register_names
      []
    end

    def to_s
      case label
      when Label
        str = label.name
      when Parfait::BinaryCode
        str = "Code"
        str += ":#{Position.get(label)}" if Position.set?(label)
      else
        str = "(no label)"
      end
      class_source( str )
    end
    alias :inspect :to_s

    # if branch_to is implemented it must return the label it branches to
    def branch_to
      label
    end
  end

  class IsZero < Branch
  end

  class IsNotZero < Branch
  end

  class IsMinus < Branch
  end

  class IsPlus < Branch
  end

end
