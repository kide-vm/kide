# Code Style and Conventions

Just  few things that have become important enough to write down. Apart from what is written here standard blah applies (ie RoboCop/Reek stuff).

## Formatting

### Line Length

While the days of 80 are over, too big steps seems difficult. I've settled on 90 (ish)

### Brackets

While ruby allows the omission of brackets even with arguments, i try to avoid that because
of readability. There may be an exception for an assignment, a single call with a single arg.
Brackets without arguments look funny though.

### Method length

Methods should not be more than 10 lines long. It points to bad design if they are,
spaghetti code, lack of abstraction and delegation. This may seem extreme coming from
other languages, and i admit it took me some years to see the light, but now it's pretty
much that. Longer methods will have a very very hard time to get accepted in a pull
request.

### No of arguments

Methods taking over 4 arguments are dubious. Actually 4 is already borderline. If a
method actually needs that much info, it is most likely that a class should be
created to hold some of it.

### Class length and size

On class length i am not rigid, but too large is a definitely a thing. More than 5-6
instance variables probably means the class is doing too much and should be split.
Also a total loc of more than 200-250 or method count over 20 is not a good sign.
Especially when combined with struct classes that just hold data and have too little
functionality, this may represent problems in pull request.

### Global and class variables

Global variables is one of the few design mistakes in ruby. They just should not exist,
meaning they should not be used.

Use class variables only if you are sure you understand their scoping, specifically the
difference between class variables and class instance variables. Lean towards
class instance variables.

Since classes (and thus modules) are global, class and module methods are global.
Use sparingly with good insight, as it ties the usage to the definition and
oo benefits like inheritance are lost.

## Code style

### Module functions are global

Often one thinks so much in classes that classes get what are basically global functions.
Global functions are usually meant for a module, so module scope is fitting.

A perfect example are singleton accessors. These are often found clumsily on the classes
but the code reads much nicer when they are on the module.

### Code generators

Instead of SlotToReg.new( register, index , register) we use Risc.slot_to_reg( name , name , name).
All names are resolved to registers, or index via Type. More readable code less repetition.
As the example shows, in this case the module function name should be the instruction class name.

Singletons should hang off the module (not the class), eg Parfait.object_space

## Naming

Naming must be one of the most important and difficult things in programming.
Spend some time to find good, descriptive names.
In the days of auto-complete, short cryptic names are not acceptable any more.

When naming, remember to name what something does (or is), not how. A classic misnomer
is the ruby Hash, which tells us how it is implemented (ie by hashing), but not it's
function. In Smalltalk this was called a Dictionary, which is tells us what it's for,
to look something up (with real-world reference, double points).
