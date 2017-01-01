ToDo
=====

Some things that would be nice . .

- Better elf support. I think it should be relatively easy to produce an executable binary
(so linking could be skipped). Off course the possibility to link in another library would be nice
- better elf tests
- better arm coverage (more instructions, better tests)
- utf8 support (string improvements generally)


Platforms
---------

x86 is up for grabs. I have intentionally started on arm (the most sold cpu) because i do
this for fun. And my pi is fun.

There is a ruby intel assembler called wilson out there. Or then there is Metasm, with
good support for many other cpu's (and a lot more code)

Compliance
----------

Is admittedly a little more fun, but also not really my goal in the near future.

If i am really honest about this, i think ruby is a little quirky around the edges and i
think a lot of that can/should be done as a compatibility layer. Keeping the core clean (and shiny).

Stdlib
------

Stdlib is not clean. More like a layer that accumulated over the years.

Very nice solutions exist for most of the important things. Like celluloid for concurrency. Celluloid-io for
good performance io with or without zero-mq. Fiddle looks nice admittedly.

Interesting
-----------

Solving concurrency is up for grabs. Any solution is a start, channels ala go are nice and
lock free stuff is the ultimate goal.
