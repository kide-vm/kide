### Virtual OO Machine

This is really an OV (object value) not object oriented machine.

Integers and References are Values. We make them look like objects, sure, but they are not.
Symbols have similar properties and those are:

- equality means identity
- no change over lifetime

It's like with Atoms: they used to be the smallest possible physical unit. Now we have electrons,
proton and neutrons. And so objects are made up of Values (not objects), integers, floats ,
references and possibly more.

Values have type in the same way objects have a class. We keep track of the type of a value at runtime,
also in an similar way that objects have their classes at runtime.

### Layers 

*Ast* instances get created by the salama-reader gem from source. 
Here we add compile functions to ast classes and  comile the ast layer into Virtual:: objects

The main objects are Space (lots of objects), BootClass (represents a class), 
CompiledMethod (with Blocks and Instruction).

**Virtual** Instructions get further transformed into **register** instructions.
This is done by an abstractly defined Register Machine with basic Intructions.
A concrete implementation (like Arm) derives and creates derived Instructions.

The transformation is implemented as **passes** to make it easier to understand what is going on.
Also this makes it easier to add functionality and optimisations from external (to the gem) sources. 

The final transformation assigns Positions to all boot objects (Linker) and assembles them into a
binary representation. The data- part is then a representation of classes in the **parfait** runtime.
And the instrucions make up the  funtions.

### Accessible Objects

Object oriented systems have data hiding. So we have access to the inner state of only four objects:

- Self
- Message (arguments, method name, self)
- Frame (local and tmp variables)
- NewMessage ( to build the next message sent)

A single instructions (Set) allows movement of data between these.
There are compare, branch and call intructions too.

### Micro

The micro-kernel idea is well stated by: If you can leave it out, do.


As such we are aiming for integer and reference (type) support, and a minimal class system 
(object/class/aray/hash/string). It is possible to add types to the system in a similar way as we add classes,
and also implement very machine dependent functionality which nevertheless is fully wrapped as OO.

**Parfait** is that part of the runtime that can be coded in ruby.
It is parsed, like any other code and always included in the resulting binary.
**Builtin** is the part of the runtime that can not be coded in ruby (but is still needed).
This is coded by construction CompiledMethods in code and neccesarily machine dependant.

