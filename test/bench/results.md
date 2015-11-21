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

ratio     | 1,3368  | 1,7699  | 0,3996  | 0,5541  | 0,6264
          | 0,7480  | 0,5650  | 2,5028  | 1,8048  | 1,5964

2c        | - 33 %  | - 79 %  | + 150%  | + 80 %  | + 60 %
