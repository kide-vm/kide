# ToDo

These are things that could be nice improvements to the current ruby-x.
Below is a list for things that are outside the scope of rubyx gem.

- Better elf support
- better elf tests
- ruby spec integration
- better arm coverage (more instructions, better tests)
- utf8 support (string improvements generally)
- risc optimisations
- register allocation

## Parfait

Improving any of the parfait classes is a simple way to get started. Most of the classes
in lib/parfait , that have an mri equivalent (like string/array/hash/integer) have a list
of methods at the bottom that need implementing (and testing)

## Github issues

Some issues already exist, any many more are obvious, just have not been written down.
If you wan to start on something, make it an issue first.

## Concurrency

Solving concurrency is up for grabs. Any solution is a start, channels ala go are nice and
lock free stuff is the ultimate goal.

## GC

No attempt has been made to garbage collect. It is not easy, and also interlinked with
concurrency, to make it even more fun. My personal thinking is that there are many more
pressing things, but if someone want to have a shot, so be it.

# External (new) gems

## Platforms

x86 is up for grabs. I have intentionally started on arm (the most sold cpu) because i do
this for fun. And my pi is fun.

There is a ruby intel assembler called wilson out there. Or then there is Metasm, with
good support for many other cpu's (and a lot more code)

## Compliance

Is admittedly a little more fun, but also not really my personal goal in the near future.

If i am really honest about this, i think ruby is a little quirky around the edges and i
think a lot of that can/should be done as a compatibility layer. Keeping the core clean (and shiny).

RubyX follows the microkernel idea: if you can leave it out, do. Most of what makes the
current mri should be external gems.

## Stdlib

Stdlib is not clean. More like a layer that accumulated over the years.

Very nice solutions exist for most of the important things.
Like celluloid for concurrency. Celluloid-io for
good performance io with or without zero-mq. Fiddle looks nice admittedly.

Stdlib should be implemented as a n external gem.


# Stary sky

Iterate:

- more cpus (ie intel)
- more systems (ie mac)
 more syscalls, there are after all some hundreds (most as external gems)
- A lot of modern cpu's functionality has to be mapped to ruby and implemented in assembler to be useful
- Different sized machines, with different register types ?
- Housekeeping (the superset of gc) is abundant
- Any amount of time could be spent on a decent digital tree (see judy). Or possibly Dr.Cliffs hash.
- Also better string/arrays would be good.
- The minor point of threads and hopefully lock free primitives to deal with that.
- Other languages, python at least, maybe others

And generally optimise and work towards that perfect world (we never seem to be able to attain).
