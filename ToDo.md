ToDo
=====


Or the list of things i am not even planning of tackling at the moment


Platforms
---------

x86 is up for grabs. I have intentionally started on arm (the most sold cpu) because i do this for fun. 
And my pi is fun.

Trying to get mainstream acknowledgement/acceptence is not fun, it's hard work and should be undertaken by 
someone with funding.

I hope to get the multi-machine architecture done at some point as i also want to port to Arduino

Compliance
----------

Is admittedly a little more fun, but also not really my goal in the near future. 

If i am really honest about this, i think ruby is a little quirky around the edges and i
think a lot of that can/should be done as a compatibility layer. Keeping the core clean (and shiny).

Stdlib
------

Stdlib is not clean. More like a layer that accumulated over the years.

Very nice solutions exist for most of the important things. Like celluloid for concurrency. Celluloid-io for 
good performance io with or without zero-mq. Fiddle looks nice addmittadly.

Anyway, as i want to use gpio mostly the whole c wrapping is not too high on the list.

My first approach would be to minkey patch any gems where they dip into things we don't have.
Or copy/port them to a smaller version.
