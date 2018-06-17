module Risc

  # A branch must branch to a label.
  # Different Branches (derived classes) use different registers, the base
  # just stores the Label
  class Branch < Instruction
    def initialize( source , label )
      super(source)
      @label = label
    end
    attr_reader :label

    def to_s
      case label
      when Label
        str = label.name
      when Parfait::BinaryCode
        str = "Code"
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

  # dynamic version of an Branch branch that jumps to the contents
  # of a register instead of a hardcoded address
  # As Branches jump to Labels, this is not derived from Branch
  # PS: to conditionally jump to a dynamic adddress we do a normal branch
  #     over the dynamic one and then a dynamic one. Save us having all types of branches
  #     in two versions
  class DynamicJump < Instruction
    def initialize( source , register )
      super(source)
      @register = register
    end
    attr_reader :register
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
