# Ruby

A representation of the ruby code.

## Concrete Syntax tree

Ruby is parsed by the parser gem (big thanks to whitequark). Own attempts at
this task have failed utterly, because ruby is a _huge_ language (and not well
defined at that)

Alas, the parser gem creates an abstract syntax tree, meaning one class is used
to represent all node types.

Imho object oriented languages have a class system to do just that, ie represent
what we may loosely call type here, ie the kind of statement.

The ruby layer is really all about defining classes for every kind of statement,
thus "typing" the syntax tree, and making it concrete.

## to Vool

In our nice layers, we are ont the way down to Vool, a simplified version of oo.

It has proven handy to have this layer, so the code for transforming each object
is in the class representing that object. (As one does in oo, again imho).

## Parfait objects

The compilation process ends up creating (parfait) objects to represent
things like classes, types and constants. This is not done here yet, but in
the vool layer.
