[![Build Status](https://travis-ci.org/ruby-x/rubyx.svg?branch=master)](https://travis-ci.org/ruby-x/rubyx)
[![Code Climate](https://codeclimate.com/github/ruby-x/rubyx/badges/gpa.svg)](https://codeclimate.com/github/ruby-x/rubyx)
[![Test Coverage](https://codeclimate.com/github/ruby-x/rubyx/badges/coverage.svg)](https://codeclimate.com/github/ruby-x/rubyx)

# RubyX

RubyX is about native code generation in and of ruby.
In other words, compiling ruby to binary, in ruby.

X can be read as 10 times faster, or a decade away, depending on mindset.

The current (fourth) rewrite adds aims at clarifying the roles of the different layers
of the system, see below. The overhaul is almost done.

Processing goes through layers: Ruby --> Vool --> Mom --> Risc --> Arm --> binary .



## Layers

### Ruby

Ruby is input layer, we use whitequarks parser to parse ruby and transform it to
Vool.

### Vool

Vool is a Virtual Object Oriented Language. Virtual in that is has no own syntax. But
it has semantics, and those are substantially simpler than ruby.

Vool is Ruby without the fluff. No unless, no reverse if/while, no splats. Just simple
oo. (Without this level the step down to the next layer was just too big)

Also Vool has a typed syntax tree, unlike the AST from the parser gem. This is easier when
writing conversion code: the code goes with the specific class (more oo than the visitor
pattern, imho)

### Mom

The Minimal Object Machine layer is the first machine layer. This means it has instructions
rather than statements. Instructions (in all machine layers) are a linked list.

Mom has no concept of memory yet, only objects. Data is transferred directly from object
to object with one of Mom's main instructions, the SlotLoad.

Mainly Mom is an easy to understand step on the way down. A mix of oo and machine. In
practise it means that the amount of instructions that need to be generated in vool
is much smaller (easier to understand) and the mapping down to risc is quite straightforward.

### RISC

The risc cpu architecture approach was a simplification of the cpu instruction set to a
minimum. Arm, our main target is a risc architecture, and the next level down.

The Risc layer here abstract the Arm in a minimal and independent way. It does not model
any real RISC cpu instruction set, but rather implements what is needed to for rubyx.

Instructions are derived from a base class, so the instruction set is extensible. This
way aditional functionality may be added by external code.

Risc knows memory and has a small set of registers. It allows memory to register transfer
and back and inter register transfer. But has no memory to memory transfer like Mom.

### Arm

There is a minimal Arm assembler that transforms Risc instructions to Arm instructions.
This is mostly a one to one mapping, though it does introduce the quirks that ARM has
and that were left out of the Risc layer.

### Elf

Arm instructions assemble themselves into binary code. A minimal Elf implementation is
able to create executable binaries from the assembled code and Parfait objects.

### Parfait

Generating code (by descending above layers) is only half the story in an oo system.
The other half is classes, types, constant objects and a minimal run-time. This is
what is Parfait is.

## Types and classes, static vs dynamic

Classes in dynamic languages are open. They can change at any time, meaning you can add/remove
methods and use any instance variable. This is the reason dynamic languages are interpreted.

For Types to make any sense, they have to be static, immutable.

Some people have equated Classes with Types, this is a basic mistake in dynamic languages.

In rubyx a Type implements a Class (at a certain time of that classes lifetime). It
defines the methods and instance variables available. This is key to generating
efficient code that uses type information to access instance variables.

When a class changes, say a new method is added that uses a new instance variable, a
**new** Type is generated to describe the class at that point. **New** code is generated
for this new Type.

In essence the Class always **has a** current Type and **many** Types implement (different
versions of) a Class.

All Objects have a Type (as their first member). The Type points to the Class that the
object has in oo terms.

Classes are defined by ruby code, but the methods of a Type (that are executed) are defined
by Mom and Risc only.

## Other

### Interpreter

After doing some debugging on the generated binaries i opted to write an interpreter for the
risc layer. That way test runs on the interpreter reveal most issues.

### Debugger

And after the interpreter was done, i wrote a [visual debugger](https://github.com/ruby-x/rubyx-debugger).
It is a simple opal application that nevertheless has proven great help both in figuring out
what is going on, and in finding bugs.

## Status

Just finishing the rewrite (above architecture) and about to get to binaries again.

### Stary sky

Iterate:

1. more cpus (ie intel)
2. more systems (ie mac)
3. more syscalls, there are after all some hundreds
5. A lot of modern cpu's functionality has to be mapped to ruby and implemented in assembler to be useful
6. Different sized machines, with different register types ?
7.  on 64bit, there would be 8 bits for types and thus allow for rational, complex, and whatnot
8. Housekeeping (the superset of gc) is abundant
9. Any amount of time could be spent on a decent digital tree (see judy). Or possibly Dr.Cliffs hash.
10. Also better string/arrays would be good.
11. The minor point of threads and hopefully lock free primitives to deal with that.
12. Other languages, python at least, maybe others
13. translation of the vm instructions to another vm, say js

And generally optimize and work towards that perfect world (we never seem to be able to attain).



Contributing to rubyx
-----------------------

Probably best to talk to me, if it's not a typo or so.

I do have a todo, for the adventurous.

Fork and create a branch before sending pulls.

== Copyright

Copyright (c) 2014/5 Torsten Ruger.
See LICENSE.txt for further details.
