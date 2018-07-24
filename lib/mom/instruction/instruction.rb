module Mom

  # Base class for MOM instructions
  # At the base class level instructions are a linked list.
  #
  # Mom::Instructions are created by the Vool level as an intermediate step
  # towards the next level down, the Risc level.
  # Mom and Risc are both abstract machines (ie have instructions), so both
  # share the linked list functionality (In Util::List)
  #
  # To convert a Mom instruction to it's Risc equivalent to_risc is called
  #
  class Instruction
    include Util::List

    # to_risc, like the name says, converts the instruction to it's Risc equivalent.
    # The Risc machine is basically a simple register machine (kind of arm).
    # In other words Mom is the higher abstraction and so mom instructions convert
    # to many (1-10) risc instructions
    #
    # The argument that is passed is a MethodCompiler, which has the method and some
    # state about registers used. (also provides helpers to generate risc instructions)
    def to_risc(compiler)
      raise self.class.name + "_todo"
    end
  end

end

require_relative "label"
require_relative "check"
require_relative "basic_values"
require_relative "simple_call"
require_relative "dynamic_call"
require_relative "block_yield"
require_relative "resolve_method"
require_relative "truth_check"
require_relative "not_same_check"
require_relative "jump"
require_relative "slot_load"
require_relative "return_sequence"
require_relative "message_setup"
require_relative "argument_transfer"
