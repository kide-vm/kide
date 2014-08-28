### Parfait: a thin layer

(not everbody likes onion)

Here we have a placeholder for things i am currently developing. 

Basically Parfait is the smallest amount of code needed to make a ruby-like OO system work.

A work in progress that started from here : http://salama.github.io/2014/06/10/more-clarity.html went on here
http://salama.github.io/2014/07/05/layers-vs-passes.html

And i finally came to the conclusion that Parfait is the ruby runtime. Aha

Run - time

not 

compile - time

always mixing those up: As such it is not loaded at compile time. On the other hand, we need to create data
at compile time that matches the expectation of the code we create..

A step back:  the code (program) we compile runs at run - time. 
And so does parfait. So all we have to do is compile it with the program.

And thus parfait can be used at run-time.

It's too simple: just slips off the mind like a fish into water.

Parfait has a brother, the Builtin module. Builtin contains everything that can not be coded in ruby, but we stil need
(things like array access).

#### Example: Message send

It felt a little stupid that it took me so long to notice that sending a message is very closely related to the
existing ruby method Object.send

Off course Object.send takes symbol and the arguments and has the receiver, so all the elements of our Messaage are there.
And the process that Object.send needs to do is exactly that: send that message, ie find the correct method according to 
the old walk up the inheritance tree rules and dispatch it.

And as all this happens at runtime, "all" we have to do is code this logic. And since it is at runtime, 
we can do it in ruby (as i said, this get's compiled and run, just like the program).

But what about the infinite loop problem:

There was a little step left out: Off course the method gets compiled at compile-time and so we don't just blindly dispatch:
we catch the simple cases that we know about: layout, type instance variables and compile time known functions. Part of 
those are some that we just don't allow to be overridden.

Also what in ruby is object.send is Message.send in salama, as it is the message we are sending and which defines all the 
data we need (not the object). The object receives, it does not send.

