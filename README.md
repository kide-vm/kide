[![Build Status](https://travis-ci.org/ruby-x/rubyx.svg?branch=master)](https://travis-ci.org/ruby-x/rubyx)
[![Code Climate](https://codeclimate.com/github/ruby-x/rubyx/badges/gpa.svg)](https://codeclimate.com/github/ruby-x/rubyx)
[![Test Coverage](https://codeclimate.com/github/ruby-x/rubyx/badges/coverage.svg)](https://codeclimate.com/github/ruby-x/rubyx)

# RubyX

RubyX is about native code generation in and of ruby.
In other words, compiling ruby to binary, in ruby.

X can be read as X times faster, or a decade away, depending on mindset.

The last rewrite clarified the roles of the different layers
of the system, see below. The overhaul is done and rubyx produces working binaries.

Processing goes through layers: Ruby --> Sol --> SlotMachine --> Risc --> Arm --> binary .

Currently most basic constructs work to some (usable) degree, ie if, while,
assignment, ivars, calling and dynamic dispatch all work. Simple blocks, those
that ruby passes implicitly also work (lambdas not).

Work continues on memory management, which turns out to be pretty basic to do just about
anything, even counting to a million.

## Layers

### Ruby

Ruby is input layer, we use whitequarks parser to parse ruby. The untyped ast is then
transformed into a typed version. The classes and fields follow the ast output pretty
much one to one. The we transform to Sol, removing much of ruby's "fluff".

### Sol

Sol is a Simple Object Language. Simple as in much simpler than ruby. Object (more
based than oriented) as everything is an object. Everything the language "sees".
(Dataprocessing is done at a lower level, partly Slot, partly risc)

Sol is Ruby without the fluff. No unless, no reverse if/while, no splats. Just simple
oo. (Without this level the step down to the next layer was just too big)


### SlotMachine

The Minimal Object Machine layer is the first machine layer. This means it has instructions
rather than statements. Instructions (in all machine layers) are a linked list.

SlotMachine has no concept of memory yet, only objects. Data is transferred directly from object
to object with one of SlotMachine's main instructions, the SlotLoad.

Mainly SlotMachine is an easy to understand step on the way down. A mix of oo and machine. In
practise it means that the amount of instructions that need to be generated in sol
is much smaller (easier to understand) and the mapping down to risc is quite straightforward.

### Risc

The risc cpu architecture approach was a simplification of the cpu instruction set to a
minimum. Arm, our main target, is a risc architecture, and much like Sol uncrinkles
Ruby, the Risc layer simplifies ARM.

The Risc layer here abstracts the Arm in a minimal and independent way. It does not model
any real RISC cpu instruction set, but rather implements what is needed for rubyx.

Instructions are derived from a base class, so the instruction set is extensible. This
way additional functionality may be added by external code.

Risc knows memory and has a small set of registers. It allows memory to register transfer
and back, and inter register transfer. But has no memory to memory transfer like SlotMachine.

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

Parfait has basic clases like string/array/hash, and also anything that is really needed
to express code, ie Class/Type/Method/Block.

Parfait is used at compile time, and the objects get serialised into the executable to
make up, or make up the executable, and are thus available at run time. Currently the
methods are not parsed yet, so do not exist at runtime yet.

### Builtin

There are a small number of methods that can not be coded in ruby. For example an
integer addition, or a instance variable access. These methods exists in any compiler,
and are called builtin here.

Builtin methods are coded at the risc level with a dsl. Even though basically assembler,
they are
([quite readable](https://github.com/ruby-x/rubyx/blob/2f07cc34f3f56c72d05c7d822f40fa6c15fd6a08/lib/risc/builtin/object.rb#L48))
through the ruby magic.

I am in the process of converting builtin to a simple language on top of SlotMachine,  
which i'm calling SlotLanguage. But this is wip.

## Types and classes, static vs dynamic

Classes in dynamic languages are open. They can change at any time, meaning you can
add/remove methods and use any instance variable. This is the reason dynamic
languages are interpreted.

For Types to make any sense, they have to be static, immutable.

Some people have equated Classes with Types, this is a basic mistake in dynamic languages.

In rubyx a Type implements a Class (at a certain time of that classes lifetime). It
defines the methods and instance variables available. This is key to generating
efficient code that uses type information to access instance variables.

When a class changes, say a new method is added that uses a new instance variable, a
**new** Type is generated to describe the class at that point. **New** code is generated
for this new Type.

In essence the Class always **has a** current Type and **many** Types implement (different versions of) a Class.

All Objects have a Type, as their first member (also integers!). The Type points to the
Class that the object has in oo terms.

Classes are defined by ruby code, but the methods of a Type (that are executed) are defined
by SlotMachine and Risc only.

## Other

### CLI

There is a basic command line interface in *bin/rubyxc* . It can be used to
- *compile* ie create an executable form a ruby source file
- *interpret* compile the given source file to risc, and run the interpreter on it
- *execute* like compile, but runs the executable (needs qemu configured)

The easiest way to execute a binary is by using qemu on your machine. Qemu comes with
commands that have a linux baked in, qemu-arm in case of arm. So running
*./bin/rubyxc hello.rb* will produce a *hello* arm executable, that can be run on any
machine  where qemu is installed with *qemu-arm ./hello* .

On my fedora, the package to install is "qemu", quite possible on mac with homebew, too.

### Interpreter

After doing some debugging on the generated binaries i opted to write an interpreter for the
risc layer. That way tests run on the interpreter reveal most issues.

### Debugger

And after the interpreter was done, i wrote a [visual debugger](https://github.com/ruby-x/rubyx-debugger).
It is a simple opal application that nevertheless has proven a great help, both in figuring
out what is going on, and in finding bugs.

## Status

The above architecture is implemented. At the top level the RubyXCompiler works
pretty much as you'd expect, by falling down the layers. And when it get's
to the Risc layer it slots the builtin in there as if is were just normal code.

Specifically here is a list of what works:
- if (with or without else)
- while
- return
- assignment (local/args/ivar)
- static calling (where method is determined at compile time)
- dynamic dispatch with caching
- implicit blocks, ie the ones that ruby passes implicitly and are used in enumerating


## Contributing to rubyx

Probably best to talk to me, if it's not a typo or so.

I've started to put some github issues out, some basic some not so. Also there is a todo
for the adventurous (bigger things, no BIG things).

Actual tasks that result in pulls, should start their life as a github issue.
There we can discuss details so that no work is done
in vain. If you're interested in an existing issues, just comment on it.

Fork and create a branch before sending pulls.

PS: I have started formulating a Democratic Open Source process, but it is still early days.
Still, if you want to help, reach out. I am hoping to initiate an alternative to the
benevolent dictator model that is currently the norm.

## Copyright

Copyright (c) 2014-20 Torsten Ruger.

See LICENSE.txt for further details.
