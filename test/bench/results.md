# Benchmarks

loop  - program does empty loop of same size as hello
hello - output hello world (to dev/null) to measure kernel calls (not terminal speed)
itos  - convert integers from 1 to 100000  to string
add   - run integer adds by linear fibonacci of 40
call  - exercise calling by recursive fibonacci of 20

Hello and puti and add run 100_000 iterations per program invocation to remove startup overhead.
Call only has 10000 iterations, as it much slower

Gcc used to compile c on the machine
soml produced by ruby (on another machine)

# Results

Results were measured by a ruby script. Mean and variance was measured until variance was low,
always under one percent.

The machine was a virtual arm run on a powerbook, performance roughly equivalent to a raspberry pi.
But results should be seen as relative, not absolute.


language  | loop    | hello   | itos    |  add    | call        
c         | 0,0500  | 2,1365  | 0,2902  | 0,1245  | 0,8535  
soml      | 0,0374  | 1,2071  | 0,7263  | 0,2247  | 1,3625

ruby      | 0,3     | 8.882    | 0,8971 | 3,8452

2c        | - 33 %  | - 79 %  | + 150%  | + 80 %  | + 60 %

2r        | x 10    | x 6     | + 23%   | x 17    | x 26

Comparison with ruby, not really for speed, just to see how much leeway there is for our next layer.
Ruby startup time is 1,5695 seconds, which we'll subtract from the benches
