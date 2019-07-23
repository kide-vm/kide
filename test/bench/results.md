# Benchmarks

hello - output hello world to measure kernel calls
add   - run integer adds by linear fibonacci of 20
call  - exercise calling by recursive fibonacci of 10
noop  - a baseline that does nothing

All programs (apart from noop) run 1M times to minimize startup impact.

C was linked statically as dynamic linked influences times. Output was sent to /dev/null, so as
to measure the calling and not the terminal.
# Results

Results were measured by a ruby script. Mean and variance was measured until variance was low,
always under one percent. Noop showed that program startup is a factor, so all programs loop to 1M.

The machine was a virtual arm (qemu) run on a acer swift 5 (i5 8265 3.9GHz), performance roughly equivalent to a raspberry pi.
But results (in ms) should be seen as relative, not absolute.


language  |  noop   |  hello  |  add    | call        
c         |  45     |  100    |  72     | 591
go        |  53     |  4060   |  64     | 624
rubyx     | 0,0374  | 1,2071  | 0,2247  | 1,3625

ruby      |  1830   | 2750    | 3000    | 1900_000

Comparison with ruby, not really for speed, just to see how much leeway there is for our next layer.
