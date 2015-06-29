# Code Style and Conventions

Just  few things that have become important enough to write down. Apart from what is written here
standard blah applies (ie RoboCop stuff).

## Formatting

### Line Length
While the days of 80 are over, too big steps seems difficult. I've settled on 100 (ish)

### Hash

I still prefer 1.9 => style , it makes the association more obvious.

## Code style

### Module functions are global

Often one thinks so much in classes that classes get what are basically global functions.
Global functions are usually meant for a module, so mmodule scope is fitting.

A perfect example are singleton accessors. These are often found clumsily on the classes but
the code reads much nicer when they are on the module.

### Code generators

Since code is represented by instances of Instructions (and subclasses) the most straightforward
way of generating code is by new of the Class. This is ok for some.

But often one finds a little massaging of the incoming data is better, while keeping that logic
out of the Instructions classes. In such cases Module functions are again quite nice. Example:

Instead of GetSlot.new( register, index , register) we use Register.get_slot( name , name , name).
All names are resolved to registers, or index via Layout. More readable code less repetition.

As the exmple shows, in this case the module function name should be the instruction class name.
