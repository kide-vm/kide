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
      Sof::Util.attributes(self).each do |a|
        begin
          left = send(a)
        rescue NoMethodError
          next  # not using instance variables that are not defined as attr_readers for equality
        end
        begin
          right = other.send(a)
        rescue NoMethodError
          return false
        end
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

  class MessageSend < Instruction
    def initialize name , me , args = []
      @name = name.to_sym
      @me = me
      @args = args
    end
    attr_reader :name , :me ,  :args
  end

  class FunctionCall < Instruction
    def initialize method
      @method = method
    end
    attr_reader :method
  end

  # class for Set instructions, A set is basically a mem move.
  # to and from are indexes into the known objects(frame,message,self and new_message), these are represented as slots
  # (see there) 
  # from may be a Constant (Object,Integer,String,Class)
  class Set < Instruction
    def initialize to , from
      @to = to
      @from = from
    end
    attr_reader :to , :from
  end

  # Get a instance variable by _name_ . So we have to resolve the name to an index to trnsform into a Slot
  # The slot may the be used in a set on left or right hand. The transformation is done by GetImplementation
  class InstanceGet < Instruction
    def initialize name
      @name = name.to_sym
    end
    attr_reader :name
  end
end
