require_relative "instruction"
require_relative "register_reference"
require_relative "assembler"
require_relative "passes/main_implementation"
require_relative "passes/frame_implementation"
require_relative "passes/message_implementation"
require_relative "passes/set_implementation"
require_relative "passes/return_implementation"
require_relative "passes/call_implementation"

# So the memory model of the machine allows for indexed access into an "object" .
# A fixed number of objects exist (ie garbage collection is reclaming, not destroying and
#  recreating) although there may be a way to increase that number.
