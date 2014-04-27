Virtual Machine 
===============

This is the logic that uses the generated ast to produce code, using the asm layer.

Apart from shuffeling things around from one layer to the other, it keeps track about registers and
provides the stack glue. All the stuff a compiler would usually do.

Also all syscalls are abstracted as functions.
