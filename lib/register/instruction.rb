module Register

  # the register machine has at least 8 registers, named r0-r5 , :lr and :pc (for historical reasons)
  # we can load and store their contents and
  # access (get/set) memory at a constant offset from a register
  # while the vm works with objects, the register machine has registers, 
  #             but we keep the names for better understanding, r4/5 are temporary/scratch
  # there is no direct memory access, only through registers
  # constants can/must be loaded into registers before use
  class Instruction

    # returns an array of registers (RegisterReferences) that this instruction uses.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r2,r3]
    # for pushes the list may be longer, whereas for a jump empty
    def uses
      raise "abstract called for #{self.class}"
    end
    # returns an array of registers (RegisterReferences) that this instruction assigns to.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r1]
    # for most instruction this is one, but comparisons and jumps 0 , and pop's as long as 16
    def assigns
      raise "abstract called for #{self.class}"
    end

    # wrap symbols into regsiter reference if needed
    def wrap_register reg
      return reg if reg.is_a? RegisterReference
      RegisterReference.new(reg)
    end
  end
  
end

require_relative "instructions/set_slot"
require_relative "instructions/get_slot"
require_relative "instructions/load_constant"
require_relative "instructions/function_call"
require_relative "instructions/function_return"
require_relative "instructions/save_return"
require_relative "instructions/register_transfer"
require_relative "instructions/register_main"
