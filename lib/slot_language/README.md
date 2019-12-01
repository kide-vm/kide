# Slot Language

This is a new layer / approach to create code for the next level, the slot_machine.

In essence the slot_language lets us code the slot_machine.

## Problem

The Problem with the current way is that some of the slot_machine instructions are
really quite complex. They are really more functions than instructions.

This is especially true for everything around the dynamic call. Dynamic call itself
is still ok, but resolve_method is too much. And it even uses method_missing, another
instruction that is too much, which in turn should use raise and now we really see
the point.

I thought about making those "super" instruction real methods and just calling them,
but the calling overhead is just too much, and really it is the wrong tool for the
job. Calling implies switching of context, while resolve_method and raise and mm
really all operate on the same context.

## The Slot Machine

The Slot Machine is a kind of memory based, oo abstraction of the risc machine, that in
turn mirrors a cpu relatively closely. The machine "knows" the message in the way a
cpu knows its registers. And the oo part means it also knows the parfait object
model.

While Ruby/Sol code only ever assumes the type of self, the Slot Machine assumes types
of the whole of Parfait. The main instruction after which the machine is named is
the SlotLoad, which moves one instance variable to another.

## Code for the Machine

Since the Slot and SlotMachine have proven useful abstractions, this introduces the
SlotLanguage as a way to create code for the SlotMachine.

The SlotMachine defines no methods on objects and passes no objects. While it has call
and return, these are defined in terms of jumps and use, like all Slot instructions,
the message.

## Syntax (projection)

Since we are not defining methods, there is no separate scope. We create objects that
will transform to SlotMachine Instructions _in_ the scope of the current method.
In other words they will have access to the compiler and the callable, when transforming
to SlotMachine (similar to Sol in that way). This means at compile time we
can use the frame type and constants, while we can always assume the Message (and not
much else) at runtime.

As the scope is "fixed", we will use the file scope, ie one file defines one
instruction/macro, by convention of the same name.

For starters we will use ruby syntax, with these semantics:
- only globals and message (the literal) are valid variable names
- dot will mean pointer traversal, sort of like c (no calling)
- names on right hand of dot must be instance variables of left
- equal will mean assignment in the SlotLoad kind of sense
- some macro mechanism is called for (tbd)
- maybe labels have to be created (sort of like the risc dsl)

The result of a compilation will be a SlotMachine Macro
