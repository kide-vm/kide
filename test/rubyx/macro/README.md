
## SlotMachine level

There are two test levels to every method. SlotMachine being the first, where we basically just
see if the right SlotMachine instruction has been generated

## Risc

Second level is to check the actual risc instructions that are generated.

Current tests test only the length, but there are some tests in interpreter dir that
test actual instructions. Should move those, as they are too detailed in a mains
(make the interpreter tests less brittle while at it.)
