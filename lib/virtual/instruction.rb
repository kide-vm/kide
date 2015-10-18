
module Virtual

  # Instruction is an abstract for all the code of the object-machine.
  # Derived classes make up the actual functionality of the machine.
  # All functions on the machine are captured as instances of instructions
  #
  # It is actually the point of the virtual machine layer to express oo functionality in the set of
  #  instructions, thus defining a minimal set of instructions needed to implement oo.

  class Instruction
  end

end

require_relative "instructions/method_call"
