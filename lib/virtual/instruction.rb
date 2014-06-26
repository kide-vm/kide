module Virtual
  
  # Instruction is an abstract for all the code of the object-machine. Derived classe make up the actual functionality
  # of the machine. 
  # All functions on the machine are captured as instances of instructions
  #
  # It is actully the point of the virtual machine layer to express oo functionality in the set of instructions, thus
  # defining a minimal set of instructions needed to implement oo.
  
  # This is partly because jumping over this layer and doing in straight in assember was too bi a step
  class Instruction
  end

end
