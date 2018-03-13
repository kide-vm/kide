# MOM , Minimal Object Machine

This layer sits between the language layer (vool) and the risc machine layer.
It is meant to make the transition (between vool and risc) easier to understand.

Previous efforts were doing the transition without an intermediate layer. But while
this was possible, it was more difficult than need be, and so we go to the old saying
that everything in computing can be fixed by another layer :-)

## Recap

A little recap of why the transition was too steep will naturally reveal the design of MOM.

### Structure

Vool has a tree structure. Risc is a linked list, so essentially flat.

### Memory model

Vool has no memory, it has objects and they just are. Risc on the other hand has only registers
and memory. Data can only move to/from/between registers, ie not from memory to memory.
While Risc knows about objects, it deals in machine words.

### Execution model

Vool's implicit execution model would be interpretation, ie tree traversal. Vool has high level
control structures, including send, and no goto, it is a language after all.

Risc is close to a cpu, it has a current instruction (pc), registers (8) and a register based
instruction set. Risc has word comparisons and a jump. Call is not used as the stack is not
used (stacks are messy, not oo)

## Design

The *essential* step from vool to risc, is the one from a language to a machine. From statements
that hang in the air, to an instruction set.
So to put a layer in the middle of those two, MOM will be:

### Linked list

But, see below, in two steps

### Use object memory

object to object transfer

no registers

### Instruction based

So a machine rather than a language. No control structures, but compare and jump instructions.

No send or call, just objects and jump.

Again in two steps, see below

Machine capabilities (instructions) for basic operations. Use of macros for higher level.

## Two step approach

To make the transition even easier, it is done in two steps.

## 1. Everything but control structures

wSo we go from language to machine as the first step, in terms of memory instructions.
Memory gets moved around between the main machine objects (frames and messages).
But control structures stay "intact", so we stay at tree structure

## 2. Flattening control structures

By flattening control structures and introducing jumps instead, we go from tree to linked
list of instructions.

After this, it is quite trivial to translate to risc, as it mostly expands instructions.

## The future

I hope that in the future this simple 2 stage pipeline will expand into more steps.
This is the ideal layer to do code analysis and meaningful optimisations, as one can still
understand what is going on in higher terms.
