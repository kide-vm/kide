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
usually under one percent.

The machine was a virtual arm run on a powerbook, performance roughly equivalent to a raspberry pi.
But results should be seen as relative, not absolute.


language  | loop    | hello   | itos   |  add     | call        
c         | 0.1530  | 0.3422  | 0.871  | 0.3968   | 2.5913  
c variance| 0.0018  | 0.010   | 0.027  | 0.0013   | 0.0058
soml      | 0.1130  | 3.5778  | 3.772  | 0.6856   | 4.0325
variance  | 0.0009  | 0.021   | 0.001  | 0.0014   | 0.0035
