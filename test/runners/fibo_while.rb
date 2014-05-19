def fibonaccit(n) # n == r0
  a = 0           # a == r1
  b = 1           # b = r2
  while( n > 1 ) do                   #BUG comment lines + comments behind function calls
    tmp = a       # r3 <- r1
    a = b         # r1 <- r2
    b = tmp + b   #  r4 = r2 + r3  (r4 transient)  r2 <- r4 
    putint(b)
    n = n - 1      # r0 <- r2   for call,    #call ok  
  end             #r5 <- r0 - 1    n=n-1 through r5 tmp              
end               # r0 <- r5

fibonaccit( 10 )
