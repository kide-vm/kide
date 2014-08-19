require_relative "object"

module Virtual
  
  # Instruction is an abstract for all the code of the object-machine. 
  # Derived classes make up the actual functionality of the machine. 
  # All functions on the machine are captured as instances of instructions
  #
  # It is actually the point of the virtual machine layer to express oo functionality in the set of instructions,
  # thus defining a minimal set of instructions needed to implement oo.
  
  # This is partly because jumping over this layer and doing in straight in assember was too big a step
  class Instruction < Virtual::Object

    # simple thought: don't recurse for Blocks, just check their names
    def == other
      return false unless other.class == self.class 
      attributes.each do |a|
        left = send(a)
        right = other.send(a)
        return false unless left.class == right.class 
        if( left.is_a? Block)
          return false unless left.name == right.name
        else
          return false unless left == right
        end
      end
      return true
    end
  end

  module Named
    def initialize name
      @name = name
    end
    attr_reader :name
  end

  # the first instruction we need is to stop. Off course in a real machine this would be a syscall, but that is just 
  # an implementation (in a programm it would be a function). But in a virtual machine, not only do we need this instruction,
  # it is indeed the first instruction as just this instruction is the smallest possible programm for the machine.
  # As such it is the next instruction for any first instruction that we generate.
  class Halt < Instruction    
  end

  # following classes are stubs. currently in brainstorming mode, so anything may change anytime
  class MethodEnter < Instruction
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

  class MessageGet < Instruction
    include Named
  end
  class FrameGet < Instruction
    include Named
  end

  class MessageSend < Instruction
    def initialize name , args = []
      @name = name.to_sym
      @args = args
    end
    attr_reader :name , :args
  end

  class FrameSet < Instruction
    def initialize name , val
      @name = name.to_sym
      @value = val
    end
    attr_reader :name , :value
  end

  class MessageSet < Instruction
    def initialize name , val
      @name = name.to_sym
      @value = val
    end
    attr_reader :name , :value
  end

  class LoadSelf < Instruction
    def initialize val
      @value = val
    end
    attr_reader  :value
  end

  class ObjectGet < Instruction
    include Named
  end
end
