  # Benchmarks

hello - output hello world to measure kernel calls
add   - run integer adds by linear fibonacci of 40
call  - exercise calling by recursive fibonacci of 20
noop  - a baseline that does nothing
loop  -  just counts down, from 1M

Loop, Hello, add and call run 1M , 50k, 10k and 100 respectively,
to minimize startup impact.

C was linked statically as dynamic linked influences times.
Output was sent to /dev/null, so as to measure the calling and not the terminal.
Also output was unbuffered, because that is what rubyx implements.

# Results

Results were measured by a ruby script. Mean and variance was measured until variance was low,
always under one percent. Noop showed that program startup is a factor, so all programs loop somewhere from 1M to 100, depending on how intensive.

The machine was a virtual arm (qemu) run on a acer swift 5 (i5 8265 3.9GHz), performance roughly equivalent to a raspberry pi.
Results (in ms) should be seen as relative, not absolute.


language  |  noop   |  hello   |  add   |  call | loop        
c         |    55   |   380    |   88   |   135 |    6
go        |    52   |   450    |    9   |    77 |    2
rubyx     |    42   |   200    | 1700   |  1450 |  470
ruby      |  1570   |   650    | 1090   |  1500 |  180
mruby     |    86   |  1200    | 1370   |  2700 |  300
