Crystal
=======

Crystal is about native code generation in and of ruby. In is done.

Step 1
------

Produce binary that represents code. 
Traditionally called assembling, but there is no need for an external file representation. 

Ie only in ruby code do i want to create machine code.

Most instructions are in fact assembling correctly. Meaning i have tests, and i can use objbump to verify the correct assembler code is disasembled

I even polished the dsl an so (from the tests), this is a valid hello world:

    hello = "Hello World\n"
    @program.main do 
      mov r7, 4     # 4 == write
      mov r0 , 1    # stdout
      add r1 , pc , hello   # address of "hello World"
      mov r2 , hello.length
    	swi 0         #software interupt, ie kernel syscall
      mov r7, 1     # 1 == exit
    	swi 0
    end
    write(7 + hello.length/4 + 1 , 'hello') 

Step 2
------

Package the code into an executable. Run that and verify it's output. But full elf support (including externs) is eluding me for now.

Still, this has proven to be a good review point for the arcitecture and means no libc for now.
Full rationale on the web (pages rep for now), but it means starting an extra step

Above Hello World can ne linked and run. And will say its thing.

Step 2.1
--------

Start implementing syscalls and add the functionality we actually need from c (basic io only really)

Step 3
-------

Start parsing some simple code. Using Parslet.

This is where it is at. Simple things transform nicely with parslet. 

But the glue is eluding me.

Get the parse - compile - execute -verify cycle going.

Step 4
-------

Implement function calling to modularise.
Implement a way to call libc

Step 5
------

Implement classes,  implement Core library of arrays/hash

Step 6
------

Implement Blocks

Step 7
------

Implement Exceptions

Step 8
-------


Celebrate New year 2020



Contributing to crystal
-----------------------
 
Probably best to talk to me, if it's not a typo or so.

I do have a todo, for the adventurous.

Fork and create a branch before sending pulls.

== Copyright

Copyright (c) 2014 Torsten Ruger. See LICENSE.txt for
further details.

