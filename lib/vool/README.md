# VOOL

Virtual Object Oriented Language
--------------------------------

in other words, ruby without the fluff.

Possibly later other languages can compile to this level and use rx-file as code definition.

## Syntax tree

Vool is a layer with concrete syntax tree, just like the ruby layer above.
Vool is just simplified, without fluff, see below.

The next layer down is the SlotMachine, Minimal object Machine, which uses an instruction list.

The nodes of the syntax tree are all the things one would expect from a language,
if statements and the like. There is no context yet, and actual objects,
representing classes and methods, will be created on the way down.

## Fluff

Ruby has lots of duplication to help programmers to write less. An obvious example is the
existence of until, which really means if not. Other examples, some more impactful are:

- No implicit blocks, those get passed as normal arguments (the last)
- No splats
- no case
- no elseif (no unless, no ternary operator)
- no global variables.

## Parfait objects

The compilation process ends up creating (parfait) objects to represent
things like classes, types and constants. This is done in this layer,
on the way down to SlotMachine (ie not during init)
