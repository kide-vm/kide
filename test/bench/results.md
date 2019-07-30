# Benchmarks

hello - output hello world to measure kernel calls
add   - run integer adds by linear fibonacci of 20
call  - exercise calling by recursive fibonacci of 10
noop  - a baseline that does nothing

All programs (apart from noop) run 100k times to minimize startup impact.

C was linked statically as dynamic linked influences times.
Output was sent to /dev/null, so as to measure the calling and not the terminal.
Also output was unbuffered, because that is what rubyx implements.

# Results

Results were measured by a ruby script. Mean and variance was measured until variance was low,
always under one percent. Noop showed that program startup is a factor, so all programs loop
to 100k.

The machine was a virtual arm (qemu) run on a acer swift 5 (i5 8265 3.9GHz), performance roughly equivalent to a raspberry pi.
Results (in ms) should be seen as relative, not absolute.


language  |  noop   |  hello   |  add   |  call        
c         |    45   |  3480    |   72   |   591
go        |    53   |  4000    |   64   |   624
rubyx     |    47   |  1660    |  800   |  2000
ruby      |  1570   |  8240    | 2700   | 12370
mruby     |   108   | 11210    | 1580   | 23400
