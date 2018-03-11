# Parfait: a thin layer

Parfait is the run-time of the object system.
To be more precise, it is that part of the run-time needed to boot.

The run-time needs to contain quite a lot of functionality for a dynamic system.
And a large part of that functionality must actually be used at compile time too.

We reuse the Parfait code at compile-time, to create the data for the compiled code.
To do this the compiler (re) defines the object memory (in parfait_adapter).

A work in progress that started from here : http://ruby-x.org/2014/06/10/more-clarity.html
went on here http://ruby-x.org/2014/07/05/layers-vs-passes.html

A step back:  the code (program) we compile runs at run - time.
And so does parfait. So all we have to do is compile it with the program.

And thus parfait can be used at run-time.

It's too simple: just slips off the mind like a fish into water.

Parfait has a brother, the Builtin module. Builtin contains everything that can not be coded in
ruby, but we still need (things like List access).

## Vm vs language- core

Parfait is not the language core library. Core library functionality differs between
languages and so the language core lib must be on top of parfait.

To make this point clear, i have started using different names for the core classes. Hopefully
more sensible ones, ie List instead of Array, Dictionary instead of Hash.

Also Parfait is meant to be as thin as humanly possibly, so extra (nice to have) functionality
will be in future modules.
