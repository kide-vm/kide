module Virtual


  # the first instruction we need is to stop. Off course in a real machine this would be a syscall,
  # but that is just  an implementation (in a programm it would be a function).
  # But in a virtual machine, not only do we need this instruction,
  # it is indeed the first instruction as just this instruction is the smallest possible programm
  # for the machine.
  # As such it is the next instruction for any first instruction that we generate.
  class Halt < Instruction
  end
end
