# Testing

Tdd, Bdd , Xdd, whatever you call it, i have come to the point where it
is a way not only to write software, but to think about software. Ie:
- if it's not tested, we don't know it works
- test first makes me think about the software from the outside. (good perspective)


I used minitest as the framework, just because it is lighter and thus when the
time comes to move to rubyx, less work.

### All

''''
  ruby test/test_all.rb
''''

### Parfait, Risc , Arm , SlotMachine

Follow the directory structure of the source and may be called unit tests

### Risc/Interpreter

Contains many system tests that rely on everything else working.
Should be hoisted i guess.

### Main

Much like the Interpreter test, but for Arm. This is where the currently few
executables are generated and there is an automatic way of running them remotely.

The plan is to integrate this with the interpreter directory
