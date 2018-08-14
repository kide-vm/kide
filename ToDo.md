ToDo
=====

Some things that would be nice . .

- Better elf support. I think it should be relatively easy to produce an executable binary
(so linking could be skipped). Off course the possibility to link in another library would be nice
- better elf tests
- better arm coverage (more instructions, better tests)
- utf8 support (string improvements generally)


## Platforms

x86 is up for grabs. I have intentionally started on arm (the most sold cpu) because i do
this for fun. And my pi is fun.

There is a ruby intel assembler called wilson out there. Or then there is Metasm, with
good support for many other cpu's (and a lot more code)

## Compliance

Is admittedly a little more fun, but also not really my personal goal in the near future.

If i am really honest about this, i think ruby is a little quirky around the edges and i
think a lot of that can/should be done as a compatibility layer. Keeping the core clean (and shiny).

## Stdlib

Stdlib is not clean. More like a layer that accumulated over the years.

Very nice solutions exist for most of the important things.
Like celluloid for concurrency. Celluloid-io for
good performance io with or without zero-mq. Fiddle looks nice admittedly.

## Concurrency

Solving concurrency is up for grabs. Any solution is a start, channels ala go are nice and
lock free stuff is the ultimate goal.

## Stary sky

Iterate:

1. more cpus (ie intel)
2. more systems (ie mac)
3. more syscalls, there are after all some hundreds (most as external gems)
5. A lot of modern cpu's functionality has to be mapped to ruby and implemented in assembler to be useful
6. Different sized machines, with different register types ?
7.  on 64bit, there would be 8 bits for types and thus allow for rational, complex, and whatnot
8. Housekeeping (the superset of gc) is abundant
9. Any amount of time could be spent on a decent digital tree (see judy). Or possibly Dr.Cliffs hash.
10. Also better string/arrays would be good.
11. The minor point of threads and hopefully lock free primitives to deal with that.
12. Other languages, python at least, maybe others

And generally optimise and work towards that perfect world (we never seem to be able to attain).
