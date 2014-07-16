Von Neumann Machine 
===============

This is the logic that uses the generated ast to produce code, using the asm layer.

Apart from shuffeling things around from one layer to the other, it keeps track about registers and
provides the stack glue. All the stuff a compiler would usually do.

Also all syscalls are abstracted as functions.

The Sapphire Convention 
----------------------

Since we're not in c, we use the regsters more suitably for our job:

- return register is _not_ the same as passing registers
- we pin one more register (ala stack/fp) for type information (this is used for returns too)
- one line (8 registers) can be used by a function (caller saved?)
- rest are scratch and may not hold values during call

For Arm this works out as:
- 0 type word (for the line)
- 1-6 argument passing + workspace
- 7 return value

This means syscalls (using 7 for call number and 0 for return) must shuffle a little, but there's space to do it.
Some more detail:

1 - returning in the same register as passing makes that one register a special case, which i want to avoid. shuffling it gets tricky and involves 2 moves for what?
As i see it the benefitd of reusing the same register are one more argument register (not needed) and easy chaining of calls, which doen't really happen so much.
On the plus side, not using the same register makes saving and restoring registers easy (to implement and understand!). 
An easy to understand policy is worth gold, as register mistakes are HARD to debug and not what i want to spend my time with just now. So that's settled.

2 - Tagging integers like MRI/BB is a hack which does not extend to other types, such as floats. So we don't use that and instead carry type information externally to the value. This is a burden off course, but then so is tagging. 
The convention (to make it easier) is to handle data in lines (8 words) and have one of them carry the type info for the other 7. This is also the object layout and so we reuse that code on the stack.

