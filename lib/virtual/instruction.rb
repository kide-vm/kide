require_relative "object"

module Virtual
  
  # Instruction is an abstract for all the code of the object-machine. Derived classe make up the actual functionality
  # of the machine. 
  # All functions on the machine are captured as instances of instructions
  #
  # It is actully the point of the virtual machine layer to express oo functionality in the set of instructions, thus
  # defining a minimal set of instructions needed to implement oo.
  
  # This is partly because jumping over this layer and doing in straight in assember was too big a step
  class Instruction < Virtual::Object
    attr_accessor :next
    def attributes
      [:next]
    end
    def initialize nex = nil
      @next = nex
    end
    # simple thought: don't recurse for labels, just check their names
    def == other
      return false unless other.class == self.class 
      attributes.each do |a|
        left = send(a)
        right = other.send(a)
        return false unless left.class == right.class 
        if( left.is_a? Label)
          return false unless left.name == right.name
        else
          return false unless left == right
        end
      end
      return true
    end
    
  end

  module Named
    def initialize name , nex = nil
      super(nex)
      @name = name
    end
    attr_reader :name
    def attributes
      [:name ] + super
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

  #resolves to nothing, but allows forward definition
  class Label < Instruction
    include Named
  end

  # the next instruction represents the true branch and the other is the .... other
  # could have been the false, but false is a keyword and is asymetric to next anyway
  # this is an abstract base class (though no measures are taken to prevent instantiation) and derived
  # class names indicate the actual test
  class Branch < Instruction
    @@counter = 1   #naming the braches by counting mainly to get them back together in testing
    # TODO, while above sounds ok at first, it messes up with different test order fails etc, as the counter will 
    # be different. Need a better way to create a unique but repeatable name
    def initialize name , nex = nil , other = nil
      super(nex)
      unless(name.to_s.split("_").last.to_i > 0)
        name = "#{name}_#{@@counter}".to_sym 
        @@counter += 1
      end
      @name = name
      @other = other
      if other
        label = self.next
        while label
          break if label.is_a?(Label) and label.name == name
          label = label.next
        end
        before_label = self.other
        while before_label.next
          break if before_label.next.is_a?(Label) and before_label.next.name == name
          before_label = before_label.next
        end
        before_label.next = label
      end
    end
    attr_reader :name
    attr_accessor :other
    def attributes
      [:name , :next , :other]
    end
    # so code can be "poured in" in the same way as normal, we swap the braches around in after the true condition
    # and swap them back after
    def swap
      tmp = @other
      @other = @next
      @next = tmp
    end
  end

  # implicit means there is no explcit test involved.
  # normal ruby rules are false and nil are false, EVERYTHING else is true (and that includes 0)
  class ImplicitBranch < Branch
  end

  # A note: future branch conditions include OverflowBranch and other non-c 
  class FrameGet < Instruction
    include Named
  end

  class FrameSend < Instruction
    def initialize name , args = [] , nex = nil
      super(nex)
      @name = name.to_sym
      @args = args
    end
    attr_reader :name , :args
    def attributes
      [:name , :args ] + super
    end
  end

  class FrameSet < Instruction
    def initialize name , val , nex = nil
      super(nex)
      @name = name.to_sym
      @value = val
    end
    attr_reader :name , :value
    def attributes
      [:name , :value] + super
    end
  end

  class LoadSelf < Instruction
    def initialize val , nex = nil
      super(nex)
      @value = val
    end
    attr_reader  :value
    def attributes
      [:value] + super
    end
  end

  class ObjectGet < Instruction
    include Named
  end
end
