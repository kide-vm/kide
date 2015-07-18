
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

require_relative "instructions/branch"
require_relative "instructions/halt"
require_relative "instructions/instance_get"
require_relative "instructions/message_send"
require_relative "instructions/method_call"
require_relative "instructions/method_enter"
require_relative "instructions/method_return"
require_relative "instructions/new_frame"
require_relative "instructions/new_message"
require_relative "instructions/set"
require_relative "instructions/virtual_main"
