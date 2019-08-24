# Code Style and Conventions

Just  few things that have become important enough to write down. Apart from what is written here standard blah applies (ie RoboCop/Reek stuff).

## Formatting

### Line Length

While the days of 80 are over, too big steps seems difficult. I've settled on 90 (ish)

### Brackets

While ruby allows the omission of brackets even with arguments, i try to avoid that because
of readability. There may be an exception for an assignment, a single call with a single arg.
Brackets without arguments look funny though.

## Code style

### Module functions are global

Often one thinks so much in classes that classes get what are basically global functions.
Global functions are usually meant for a module, so module scope is fitting.

A perfect example are singleton accessors. These are often found clumsily on the classes but
the code reads much nicer when they are on the module.

### Code generators

Instead of SlotToReg.new( register, index , register) we use Risc.slot_to_reg( name , name , name).
All names are resolved to registers, or index via Type. More readable code less repetition.
As the example shows, in this case the module function name should be the instruction class name.

Singletons should hang off the module (not the class), eg Parfait.object_space
