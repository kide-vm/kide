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

The compiler has a method for each type for ast, named along on_xxx with xxx as the type

#### Compiler holds scope

The Compiler instance can hold arbitrary scope needed during the compilation. Since we compile Phisol
(a static language) things have become more simple.

A class statement sets the current @clazz scope , a method definition the @method.
If either are not set when needed compile errors will follow. So easy, so nice.

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

When a Method needs to make a call, it creates a NewMessage object.
Messages contain return addresses (yes, plural) and arguments.

The important thing here is that Messages and Frames are normal objects.

### Distinctly future proof

Phisol is designed to be used as an implementation language for a higher oo language. Some, or
even many, features may not make sense on their own. But these features, like several return
addresses, are important to implement the higher language.

In fact, Phisol's main purpose is not even to be written. The main purpose is to have a language to
compile ruby to. In the same way that the assembler layer in salama is not designed to be written,
we just need it to create our layers.
