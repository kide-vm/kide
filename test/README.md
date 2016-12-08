# Testing

Testing is off course great, and well practised in the ruby community.
Good tests exists in the parts where functionality is clear: Parsing and binary generation.

But it is difficult to write tests when you don't know what the functionality is.
Also TDD does not really help as it assumes you know what you're doing.

I used minitest as the framework, just because it is lighter and thus when the
time comes to move to salama, less work.

### All

''''
  ruby test/test_all.rb
''''

### Parfait

Well, test Parfait. Not perfect, but growing as bugs appear. Basics are ok though.

### Compiler

Different kinds of quite minimal tests that ensure we can go from parsed to code.

### Fragments

Much more elaborate tests of the compling functionality. All code constructs and their output
in terms of instructions are tested.

### vm

Mostly tests about the Parfait compatibility layer and padding (for assmenbly).
Slightly bad name ... wip
