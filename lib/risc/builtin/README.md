### Builtin module

The Builtin module contains functions that can not be coded in ruby.
It is the other side of the parfait coin, part of  the runtime.

The functions are organized by their respective class and get loaded in boot_classes! ,
right at the start. (see register/boot.rb)

These functions return their code, ie a Parfait::TypedMethod with a MethodSource object,
which can then be called by ruby code as if it were a "normal"  function.

A normal ruby function is one that is parsed and transformed to code. But not all functionality can
be written in ruby, one of those chicken and egg things.
C uses Assembler in this situation, we use Builtin functions.

Slightly more here : http://ruby-x.org/2014/06/10/more-clarity.html (then still called Kernel)

The Builtin module is scattered into several files, but that is just so the file doesn't get too long.
