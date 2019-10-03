# The *essential* step from vool to risc, is the one from a language to a machine.
# From vools statements that hang in the air, to an instruction set.
#
# ### List based:  Bit like Risc, just no registers
#
# ### Use object memory :  object to object transfer + no registers
#
# ### Instruction based
#
# So a machine rather than a language. No control structures, but compare and jump
# instructions. No send or dynamic call, just objects and jump.
# Machine capabilities (instructions) for basic operations.
# Use of macros for higher level.

require_relative "instruction.rb"
require_relative "slot_collection"
require_relative "callable_compiler"
require_relative "method_compiler"
require_relative "block_compiler"
require_relative "macro/macro"
