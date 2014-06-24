module Vm
  # The ObjectMachine is the object-oriented virtual machine in which ruby is implemented.
  # 
  # It is minimal and realistic and low level
  # - minimal means that if one thing can be implemented by another, it is left out. This is quite the opposite from
  #          ruby, which has several loops, many redundant if forms and the like.
  # - realistic means it is easy to implement on a 32 bit machine (arm) and possibly 64 bit. Memory access, a stack,
  #    some registers of same size are the underlying hardware. (not ie byte machine)
  # - low level means it's basic instructions are realively easily implemented in a register machine. ie send is not
  #   a an instruction but a function.
  #
  # A better name may be Value-based machine. Ie all "objects" are values, all passing is value based.
  # The illusion of objects is created by a value called object-reference.
  #
  # So the memory model of the machine allows for indexed access into and "object" . A fixed number of objects exist
  # (ie garbage collection is reclaming, not destroying and recreating) although there may be a way to increase that number.
  #
  # The ast is transformed to object-machine objects, some of which represent code, some data.
  # 
  # The next step transforms to the register machine layer, which is what actually executes. 
  #

  # More concretely, an object machine is a sort of oo turing machine, it has a current instruction, executes the
  # instructions, fetches the next one and so on.
  # Off course the instructions are not soo simple, but in oo terms quite so.
  # 
  # The machine has a no register, but local variables, a scope at each point in time. 
  # Scope changes with calls and blocks, but is saved at each level. In terms of lower level implementation this means
  # that the the model is such that what is a variable in ruby, never ends up being just on the cpu stack.
  # 
  class ObjectMachine
  end
end
