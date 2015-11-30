[![Build Status](https://travis-ci.org/salama/salama.svg?branch=master)](https://travis-ci.org/salama/salama)
[![Gem Version](https://badge.fury.io/rb/salama.svg)](http://badge.fury.io/rb/salama)
[![Code Climate](https://codeclimate.com/github/salama/salama/badges/gpa.svg)](https://codeclimate.com/github/salama/salama)
[![Test Coverage](https://codeclimate.com/github/salama/salama/badges/coverage.svg)](https://codeclimate.com/github/salama/salama)

# Salama

Salama is about native code generation in and of ruby.

It is probably best to read the [The Book](http://dancinglightning.gitbooks.io/the-object-machine/content/) first.

The current third rewrite adds a system language, with the idea of compiling ruby to that language, Soml.
The original ruby parser has been remodeled to parse Soml and later we will use whitequarks
parser to parse ruby.  Then it will be ruby --> Soml --> assembler --> binary .


## Done

Some things that are finished, look below for current status / work

### Soml

A working of the [system language](http://salama-vm.org/soml/soml.html) is done. It is
strongly typed, but leans more towards ruby style syntax.

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

Having finished Soml, it's time to compile ruby to it.

This will mean more work on the type front.


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
