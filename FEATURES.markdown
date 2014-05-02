Features
--------

After having written a todo i thought it may be good to collect thoughts on where this is going.
(No real order here, just what pops when it pops)

- Multi cpu / architecture from the same parse. Ie by instantiation not module inclusion or things that can't 
    be undone during the execution time of ruby
    
- A minimal binary should be very very small (for Arduino). The program being created should determine features that are being "pulled in". Ie if it's not ruby we want to create, the parser should be left out etc. Libc only for programs that have an os to run on, dynamic memory dito.
