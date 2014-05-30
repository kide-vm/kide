#Crystal


Crystal is about native code generation in and of ruby. In is done.

### Step 1 - Assembly

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

### Step 2 -Link to system

Package the code into an executable. Run that and verify it's output. But full elf support (including externs) is eluding me for now.

Still, this has proven to be a good review point for the arcitecture and means no libc for now.
Full rationale on the web (pages rep for now), but it means starting an extra step

Above Hello World can be linked and run. And will say its thing.

### Step 3 - syscalls

Start implementing some syscalls and add the functionality we actually need from c (basic io only really)

### Step 4 -Parse ruby

Parse simple code, using Parslet. 

Parsing is a surprisingly fiddly process, very space and order sensitive. But Parslet is great and simple
expressions (including function definitions and calls) are starting to work.

I Spent some time on the parse testing framework, so it is safe to fiddle and add.

### Step 5 - Vm: Compile the Ast

Since we now have an Abstact syntax tree, it needs to be compiled to a machine Instruction format.

The machine/instruction/data definitions make up the Virtual Machine layer (vm directory)

After some trying around, something has emerged. As it uses the instructions from Step 1, we are ready to say
our hellos in ruby

puts("Hello World")

was the first to make the trip: parsed to ast, compiled to Instructions/Code, linked and assembled to binary
and executed, gives the surprising output of "Hello World"

Time to add some meat.

### Step 6 - Register allocation

A first version of register allocation is done. I moved away from the standard c calling convention to pin a 
type register and also not have passing and return overlapping.
That at least simplified thinking about register allocation. One has to remember the machine level is completely
value and pass by value based.

As a side i got a return statement done now, and implicit return at the end has been working. Just making sure all
branches actually return implicitly is not done. But no rush there, as one can always write the return explicitly.

### Step 7 - Basic type instructions

As we want to work on values, all the value methods have to be implemented to map to machine instructions.

Some are done, most are not. But they are straightforward.

### Step 8 - Object creation

Move to objects, static memory manager, class, superclass, metaclass stuff

### Step 9 - Compound types

Arrays and Hash parse. Good. But this means The Actual datastructures should be implemented. AWIP ( a work in progress)

Implement Core library of arrays/hash/string , memory definition and access

### Step 10

Implement Blocks, stack/external frames

### Step 11

Implement Exceptions, frame walking

### Step 12

Implement a way to call libc

### Step 13

Iterate from one:

1. more cpus (ie intel)
2. more systems (ie mac)
3. more syscalls, there are after all some hundreds
4. Ruby is full of nicities that are not done, also negative tests are non existant
5. A lot of modern cpu's functionality has to be mapped to ruby and implemented in assembler to be useful
6. Different sized machines, with different register types ?
7.  on 64bit, there would be 8 bits for types and thus allow for rational, complex, and whatnot
8. Housekeeping (the superset of gc) is abundant
9. Any amount of time could be spent on a decent digital tree (see judy). Also better string/arrays would be good.
10. Inlining would be good

And generally optimize and work towards that perfect world (we never seem to be able to attain).

### Step 14

Celebrate New year 2030



Contributing to crystal
-----------------------
 
Probably best to talk to me, if it's not a typo or so.

I do have a todo, for the adventurous.

Fork and create a branch before sending pulls.

== Copyright

Copyright (c) 2014 Torsten Ruger. See LICENSE.txt for
further details.

