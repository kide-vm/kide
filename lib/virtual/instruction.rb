module Virtual
  
  # Instruction is an abstract for all the code of the object-machine. Derived classe make up the actual functionality
  # of the machine. 
  # All functions on the machine are captured as instances of instructions
  #
  # It is actully the point of the virtual machine layer to express oo functionality in the set of instructions, thus
  # defining a minimal set of instructions needed to implement oo.
  
  # This is partly because jumping over this layer and doing in straight in assember was too big a step
  class Instruction
    attr_accessor :next
    
    def inspect
      self.class.name + ".new()"
    end
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

  class FrameGet < Instruction
    def initialize name
      @name = name
    end
  end

  class FrameSend < Instruction

    def initialize name , args = []
      @name = name.to_sym
      @args = args
    end
    attr_reader :name , :args
    
    def == other
      self.class == other.class && self.name == other.name
    end
    def inspect
      self.class.name + ".new(:#{@name} , [ " + args.collect{|a| a.inspect}.join(",")+ "])"
    end
  end

end
