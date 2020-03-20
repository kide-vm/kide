module Risc
  # dynamic version of an Branch that jumps to the contents
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

    # return an array of names of registers that is used by the instruction
    def register_attributes
      [:register ]
    end

    def to_s
      class_source( register.to_s)
    end
  end

  # A Dynamic yield is very much like a DynamicJump, especially in it's idea
  #
  # The implentation differes slightly, as we use a chache entry in the DynamicJump
  # but a block in the DynamicYield.
  # Using means that we assume the register to be ready loaded with a Block
  class DynamicYield < DynamicJump
  end
end
