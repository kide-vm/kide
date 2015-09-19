### Compiling

The Ast (abstract syntax tree) is created by [salama-reader](https://github.com/salama/salama-reader)
 gem and the classes defined there

The code in this directory compiles the AST to the virtual machine code, and Parfait object structure.

If this were an interpreter, we would just walk the tree and do what it says.
Since it's not things are a little more difficult, especially in time.

When compiling we deal with two times, compile-time and run-time.
All the headache comes from mixing those two up.*

Similarly, the result of compiling is two-fold: a static and a dynamic part.

- the static part are objects like the constants, but also defined classes and their methods
- the dynamic part is the code, which is stored as streams of instructions in the MethodSource

Too make things a little simpler, we create a very high level instruction stream at first and then
run transformation and optimization passes on the stream to improve it.

Each ast class gets a compile method that does the compilation.

#### MethodSource and Instructions

The first argument to the compile method is the MethodSource.
All code is encoded as a stream of Instructions in the MethodSource.
Instructions are stored as a list of Blocks, and Blocks are the smallest unit of code,
which is always linear.

Code is added to the method (using add_code), rather than working with the actual instructions.
This is so each compiling method can just do it's bit and be unaware of the larger structure
that is being created.
The general structure of the instructions is a graph
(with if's and whiles and breaks and what), but we build it to have one start and *one* end (return).


#### Messages and frames

Since the machine is virtual, we have to define it, and since it is oo we define it in objects.

Also it is important to define how instructions operate, which is is in a physical machine would
be by changing the contents of registers or  some stack.

Our machine is not a register machine, but an object machine: it operates directly on objects and
also has no separate stack, only objects. There are a number of objects which are accessible,
and one can think of these (their addresses) as register contents.
(And one wouldn't be far off as that is the implementation.)

The objects the machine works on are:

- Message
- Frame
- Self
- NewMessage

and working on means, these are the only objects which the machine accesses.
Ie all others would have to be moved first.

When a Method needs to make a call, or send a Message, it creates a NewMessage object.
Messages contain return addresses and arguments.

Then the machine must find the method to call.
This is a function of the virtual machine and is implemented in ruby.

Then a new Method receives the Message, creates a Frame for local and temporary variables
and continues execution.

The important thing here is that Messages and Frames are normal objects.

And interestingly we can partly use ruby to find the method, so in a way it is not just a top
down transformation. Instead the sending goes back up and then down again.

The Message object is the second parameter to the compile method, the run-time part as it were.
Why? Since it only exists at runtime: to make compile time analysis possible
(it is after all the Virtual version, not Parfait. ie compile-time, not run-time).
Especially for those times when we can resolve the method at compile time.


*
As ruby is a dynamic language, it also compiles at run-time. This line of thought does not help
though as it sort of mixes the seperate times up, even they are not.
Even in a running ruby programm the stages of compile and run are seperate.
Similarly it does not help to argue that the code is static too, not dynamic,
as that leaves us with a worse working model.
