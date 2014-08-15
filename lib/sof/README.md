### Reading the code

Knowing what's going on while coding salama is not so easy: Hnce the need to look at code dumps

Hence the need for a code/object file format (remeber an oo program is just objects, some data, some code, all objects)

I started with yaml, which is nice in that it has a solid implementation, reads and writes, handles arbitrary objects, 
handles graphs and is a sort of readable text format.

But the sort of started to get to me, because 1) it's way to verbose and 2) does not allow for (easy) ordering.
Also it was placing references in weird (first seen) places.

To fix this i started on Sof, with an eye to expand it.

The main starting goal was quite like yaml, but with

- more text per line, specifically objects with simle attributes to have a constructor like syntax
- Shorter class names (no ruby/object or even ruby/struct stuff)
- references at the most shallow level
- a possibility to order attributes and specify attributes that should not be serialized

### Salama Object File

Ok, so we all heard about object files, it's the things compilers create so we don't have to have huge compiles and
can link them later.

Much fewer know what they include, and that is not because they are not very useful, but rather very complicated.

An object machine must off course have it's own object files, because:

- otherwise we'd have to express the object machine in c (nischt gut)
- we would be forced to read the source every time (slow)
- we would have no language independant format

And i was going to get there, juust not now. I mean i think it's a great idea to have many languages compile and run 
on the same object machine. Not neccessarily my idea, but i haven't seen it pulled off. Not that i will.

I just want to be able to read my compiled code!!

And so this is a little start, just some outputter.

#### Direction

The way this is meant to go (planned for 2020+) was a salama core with only a sof parser (as that is soo much simpler).

Then to_ruby for all the ast classes to be able to roundtrip ruby code.

Then go to storing sof in git, rather than ruby.

Then write a python/java parser and respective runtime conversion. Extracting common features. With the respective 
to_python on the ast's to roundtrip that too. Have to since by now we work on sof's. Etc . ..
