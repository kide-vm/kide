Minimal elf support
===================

This is really minimal and works only for our current use case

- no external functions (all syscalls)
- only position independant code (no relocation)
- embedded data (into text), no data section

I was close to going the wilson way, ie assmble, load into memory and jump

But it is nice to produce executables. Also easier to test, what with segfaults and such.

Executalbe files are not supported (yet?), but object files work. So the only thing that remains is to
call the linker on the produced object file. The resulting file is an executable that actually works!!

Thanks to Mikko for starting this arm/elf project in the first place: https://github.com/cyndis/as

This part definately needs tlc, so anyone who is interested, dig in!