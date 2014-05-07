Crystal
=======

Crystal is about native code generation in and of ruby. In is done.

Step 1 - Assembly
-----------------

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

Step 2 -Link to system
----------------------

Package the code into an executable. Run that and verify it's output. But full elf support (including externs) is eluding me for now.

Still, this has proven to be a good review point for the arcitecture and means no libc for now.
Full rationale on the web (pages rep for now), but it means starting an extra step

Above Hello World can be linked and run. And will say its thing.

Step 2.1 -syscalls
------------------

Start implementing some syscalls and add the functionality we actually need from c (basic io only really)

Step 3 -Parse ruby
------------------

Parse simple code, using Parslet. 

Parsing is a surprisingly fiddly process, very space and order sensitive. But Parslet is great and simple
expressions (including function definitions and calls) are starting to work.

I Spent some time on the parse testing framework, so it is safe to fiddle and add.

Step 4 - Vm: Compile the Ast
---------------------------

Since we now have an Abstact syntax tree, it needs to be compiled to a machine Instruction format.

The machine/instruction/data definitions make up the Virtual Machine layer (vm directory)

After some trying around, something has emerged. As it uses the instructions from Step 1, we are ready to say
our hellos in ruby

puts("Hello World")

was the first to make the trip: parsed to ast, compiled to Instructions/Code, linked and assembled to binary
and executed, gives the surprising output of "Hello World"

Time to add some meat.

Step 5 - Register allocation
----------------------------

Unfortunately Hello world cheated a little in that it assumed knowledge of registers. Next up is a dynamic
algorithm for register allocation.

Probably using something along llvm lines (again!), ie Instructions refering to the Values theu use.
Ravel the chain up from the back, ie where things have to be at the end to make it work.

Step 6 - Basic type instructions
--------------------------------

As we want to work on values, all the value methods have to be implemented to map to machine instructions.

With optimisations there are so many!! 

Step 7 - Compound types
-----------------------

Your basic array and hash need to be parsed , and implemented along with string. Nothing much happens without
these guys. 

Step 8
-------

Implement a way to call libc

Step 9
------

Implement classes,  implement Core library of arrays/hash

Step 10
------

Implement Blocks

Step 11
------

Implement Exceptions

Step 12
-------


Celebrate New year 2030



Contributing to crystal
-----------------------
 
Probably best to talk to me, if it's not a typo or so.

I do have a todo, for the adventurous.

Fork and create a branch before sending pulls.

== Copyright

Copyright (c) 2014 Torsten Ruger. See LICENSE.txt for
further details.

