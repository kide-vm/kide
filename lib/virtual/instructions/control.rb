module Virtual
  

  # the first instruction we need is to stop. Off course in a real machine this would be a syscall, but that is just 
  # an implementation (in a programm it would be a function). But in a virtual machine, not only do we need this instruction,
  # it is indeed the first instruction as just this instruction is the smallest possible programm for the machine.
  # As such it is the next instruction for any first instruction that we generate.
  class Halt < Instruction    
  end

  class MethodReturn < Instruction
  end

  # a branch must branch to a block. This is an abstract class, names indicate the actual test
  class Branch < Instruction
    def initialize to
      @to = to
    end
    attr_reader :to
  end

  # implicit means there is no explcit test involved.
  # normal ruby rules are false and nil are false, EVERYTHING else is true (and that includes 0)
  class ImplicitBranch < Branch
  end

  class UnconditionalBranch < Branch
  end

end
