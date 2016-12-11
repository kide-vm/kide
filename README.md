[![Build Status](https://travis-ci.org/salama/salama.svg?branch=master)](https://travis-ci.org/salama/salama)
[![Gem Version](https://badge.fury.io/rb/salama.svg)](http://badge.fury.io/rb/salama)
[![Code Climate](https://codeclimate.com/github/salama/salama/badges/gpa.svg)](https://codeclimate.com/github/salama/salama)
[![Test Coverage](https://codeclimate.com/github/salama/salama/badges/coverage.svg)](https://codeclimate.com/github/salama/salama)

# Salama

Salama is about native code generation in and of ruby.

The current (fourth) rewrite adds a typed intermediate representation layer (bit like c,
but not as a language). The idea is to compile ruby to that typed representation.

We will use whitequarks parser to parse ruby.  Then it will be ruby --> Typed --> Register --> Arm --> binary .


## Done

Some things that are finished, look below for current status / work

### Typed representation

The fully typed syntax representation and compiler to the Register level is done.
It is remodeled after  last years system language, which proved the concept and
surprised with speed.

Completely object oriented, including calling convention. Not much slower than c.

### A runtime: Parfait

In a dynamic system the distinction between compile-time and run-time is blurs. But a minimum
of support is needed to get the system up, and that is [Parfait](http://salama-vm.org/soml/parfait.html)

### Interpreter

After doing some debugging on the generated binaries i opted to write an interpreter for the
register layer. That way test runs on the interpreter reveal most issues.

### Debugger

And after the interpreter was done, i wrote a [visual debugger](https://github.com/salama/salama-debugger).
It is a simple opal application that nevertheless has proven great help both in figuring out
what is going on, and in finding bugs.

## Status

Most work on the statically typed layer should be done (and produces working binaries!).

Next up: compiling ruby and typing it :-)

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



Contributing to salama
-----------------------

Probably best to talk to me, if it's not a typo or so.

I do have a todo, for the adventurous.

Fork and create a branch before sending pulls.

== Copyright

Copyright (c) 2014/5 Torsten Ruger.
See LICENSE.txt for further details.
