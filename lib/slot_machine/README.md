# SlotMachine

This layer sits between the language layer (sol) and the risc machine layer.
It is meant to make the transition (between sol and risc) easier to understand.

Previous efforts were doing the transition without an intermediate layer. But while
this was possible, it was more difficult than need be, and so we go to the old saying
that everything in computing can be fixed by another layer :-)

## Recap

A little recap of why the transition was too steep will naturally reveal the design of SlotMachine.

### Structure

Sol has a tree structure. Risc is a linked list, so essentially flat.

### Memory model

Sol has no memory, it has objects and they just are. Risc on the other hand has only registers
and memory. Data can only move to/from/between registers, ie not from memory to memory.
While Risc knows about objects, it deals in machine words.

### Execution model

Sol's implicit execution model would be interpretation, ie tree traversal. Sol has high level
control structures, including send, and no goto, it is a language after all.

Risc is close to a cpu, it has a current instruction (pc), registers (8) and a register based
instruction set. Risc has word comparisons and a jump. Call is not used as the stack is not
used (stacks are messy, not oo)

## Design

The *essential* step from sol to risc, is the one from a language to a machine. From statements
that hang in the air, to an instruction set.
So to put a layer in the middle of those two, SlotMachine will be:

### Linked list

But, very much like Risc, just higher level so it's easier to understand

### Use object memory

object to object transfer

no registers (one could see the current message as the only register)

### Instruction based

So SlotMachine is a machine layer, rather than a language.
No control structures, but compare and jump instructions.

No send or call, just objects and jump.

Again in two steps, see below

Machine capabilities (instructions) for basic operations. Use of macros for higher level.
