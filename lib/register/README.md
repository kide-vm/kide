Register Machine 
===============

This is the logic that uses the compiled virtual object space to produce code and an executable binary.

There is a mechanism for an actual machine (derived class) to generate machine specific instructions (as the 
plain ones in this directory don't assemble to binary). Currently there is only the Arm module to actually do
that.

The elf module is used to generate the actual binary from the final BootSpace. BootSpace is a virtual class representing
all objects that will be in the executable. Other than CompiledMethods, objects get transformed to data.

But CompiledMethods, which are made up of Blocks, are compiled into a stream of bytes, which are the binary code for the
function.

Virtual Objects
----------------

There are four virtual objects that are accessible (we can access their variables):

- Self
- Message (arguments, method name, self)
- Frame (local and tmp variables)
- NewMessage ( to build the next message sent)

These are pretty much the first four registers. When the code goes from virtual to register, we use register instrucitons
to replace virtual ones.

Eg: A Virtual::Set can move data around inside those objects. And since in Arm this can not be done in one instruciton,
we use two, one to move to an unused register and then into the destination. And then we need some fiddling of bits
to shift the type info.

Another simple example is a Call. A simple case of a Class function call resolves the class object, and with the
method name the function to be called at compile-time. And so this results in a Register::Call, which is an Arm 
instruction. 

A C call 
---------

Ok, there are no c calls. But syscalls are very similar. This is not at all as simple as the nice Class call described 
above. 

For syscall in Arm (linux) you have to load registers 0-x (depending on call), load R7 with the syscall number and then 
issue the software interupt instruction. If you get back something back, it's in R0.

In short, lots of shuffling. And to make it fit with our four object architecture, we need the Message to hold the data
for the call and Sys (module) to be self. And then the actual functions do the shuffle, saving the data and restoring it.
And setting type information according to kernel documentation (as there is no runtime info)
 