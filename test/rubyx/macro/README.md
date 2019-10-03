## Pre - testing builtin

In the process of moving builtin from mom to parfait. Considering we started at risc, this
is progress.

Builtin methods should (will) use the Macro idea to actually become code and land in
the parfait code.

On the way there, we start by Testing and moving the old ones. Since we want to be able
to test some methods even after the move, without parsing/processing the whole of parfait
we have to have a method of "injecting" the single? methods.

## SlotMachine level

There a re two test levels to every method. SlotMachine being the first, where we basically just
see if the right SlotMachine instruction has been generated

## Risc

Second level is to check the actual risc instructions that are generated.

Current tests test only the length, but there are some tests in interpreter dir that
test actual instructions. Should move those, as they are too detailed in a mains
(make the interpreter tests less brittle while at it.)
