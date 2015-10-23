### Builtin module

The Builtin module contains functions that can not be coded in ruby.
It is the other side of the parfait coin, part of  the runtime.

The functions are organized by their respective class and get loaded in boot_classes! ,
right at the start. (see register/boot.rb)

These functions return their code, ie a Parfait::Method with a MethodSource object,
which can then be called by ruby code as if it were a "normal"  function.

A normal ruby function is one that is parsed and transformed to code. But not all functionality can
be written in ruby, one of those chicken and egg things.
C uses Assembler in this situation, we use Builtin functions.

Slightly more here : http://salama.github.io/2014/06/10/more-clarity.html (then still called Kernel)

The Builtin module is scattered into several files, but that is just so the file doesn't get too long.

Note: This is about to change slightly with the arrival of Soml.  Soml is a lower level function,
and as such there is not much that we need that can not be expressed in it. My current thinking
is that i can code anything in Soml and will only need the Soml instruction set.
So this whole Builtin approach may blow over in the next months. It had already become clear that
mostly this was going to be about memory access, which in Soml is part of the language.
