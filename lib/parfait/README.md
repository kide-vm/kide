### Parfait: a thin layer

Parfait is the run-time of the **vm**.
To be more precise, it is that part of the run-time needed to boot ruby.

The run-time needs to contain quite a lot of functionality for a dynamic system.
And a large part of that functionality must actually be used at compile time too.

We reuse the Parfait code at compile-time, to create the data for the compiled vm.
To do this the vm (re) defines the object memory (in parfait_adapter).

To do the actual compiling we parse and compile the parfait code and inline it to
appropriate places (ie send, get_instance_variable etc). We have to inline to avoid recursion.

A work in progress that started from here : http://salama.github.io/2014/06/10/more-clarity.html
went on here http://salama.github.io/2014/07/05/layers-vs-passes.html

A step back:  the code (program) we compile runs at run - time.
And so does parfait. So all we have to do is compile it with the program.

And thus parfait can be used at run-time.

It's too simple: just slips off the mind like a fish into water.

Parfait has a brother, the Builtin module. Builtin contains everything that can not be coded in ruby,
but we still need (things like List access).

#### Example: Message send

It felt a little stupid that it took me so long to notice that sending a message is very closely
related to the existing ruby method Object.send

Off course Object.send takes symbol and the arguments and has the receiver, so all the elements of our
Message are there. And the process that Object.send needs to do is exactly that:
send that message, ie find the correct method according to the old walk up the inheritance tree rules and dispatch it.

And as all this happens at runtime, "all" we have to do is code this logic. And since it is at runtime,
we can do it in ruby (as i said, this get's compiled and run, just like the program).

But what about the infinite loop problem:

There was a little step left out: Off course the method gets compiled at compile-time and so
we don't just blindly dispatch: we catch the simple cases that we know about:
layout, type instance variables and compile time known functions.
Part of those are some that we just don't allow to be overridden.

Also what in ruby is object.send is Message.send in salama, as it is the message we are sending and
which defines all the  data we need (not the object). The object receives, it does not send.

### Vm vs language- core

Parfait is not the language (ie ruby) core library. Core library functionality differs between
languages and so the language core lib must be on top of the vm parfait.

To make this point clear, i have started using different names for the core classes. Hopefully
more sensible ones, ie List instead of Array, Dictionary instead of Hash.

Also Parfait is meant to be as thin as humanly possibly, so extra (nice to have) functionality
will be in future modules.

So the Namespace of the Runtime is actually Parfait (not nothing as in ruby).
Only in the require does one later have to be clever and see which vm one is running in and either
require or not. Maybe one doesn't even have to be so clever, we'll see (as requiring an existing
module should result in noop)
