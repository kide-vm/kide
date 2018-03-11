# VOOL

Virtual Object Oriented Language
--------------------------------

in other words, ruby without the fluff.

Possibly later other languages can compile to this level and use rx-file as code definition.

## Syntax tree

Vool is the layer of concrete syntax tree. The Parser gem is used to parse ruby. It creates
an abstract syntax tree which is then transformed.

The next layer down is the Mom, Minimal object Machine, which uses an instruction tree.
That is on the way down we create instructions, but stays in tree format. Only the next step
down to the Risc layer moves to an instruction stream.

The nodes of the syntax tree are all the things one would expect from a language, if statements
and the like. There is no context yet, and actual objects, representing classes and
methods, will be created on the way down.

## Fluff

Ruby has lots of duplication to help programmers to write less. An obvious example is the
existence of until, which really means if not. Other examples, some more impactful are:

- No implicit blocks, those get passed as normal arguments (the last)
- No splats
- no case
- no elseif (no unless, no ternary operator)
- no global variables.
