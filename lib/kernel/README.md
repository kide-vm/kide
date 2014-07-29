### Kernel module

As of writing Kernel is an "old style" module, aka a bunch of functions.

These functions return their code, ie a Vm::Function object, which can then be called by ruby code as if it were a "normal" 
function.

A normal ruby function is one that is parsed and transformed to code. But not all functionality can be written in ruby, 
one of those chicken and egg things. C uses Assembler in this situation, we use Kernel function.

Slightly more here : http://salama-vm.github.io/2014/06/10/more-clarity.html

The Kernal module is scattered into several files, but that is just so the file doesn't get too long.

PS: Old style also means the acual receiver is not used. Kernel function are more like global functions.
PPS: New style is what rails pioneered and has now called Concerns. I call them Aspects, and they not only serve to split
a big file up, but use the receiver and also super, ie the fact that a module gets inserted into the method lookup 
 sequence in just the same way as an superclass. This solves the old c++ and Java multiple inheritance dilemma. 
 