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
      class_source "#{label ? label.name : '(no label)'}"
    end
    alias :inspect :to_s

  end

  # dynamic version of an Unconditional branch that jumps to the contents
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

  class Unconditional < Branch

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
