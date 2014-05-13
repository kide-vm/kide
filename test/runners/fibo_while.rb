def fibonaccit(n)
  a = 0 
  b = 1
  while( n > 1 ) do
    tmp = a
    a = b
    b = tmp + b
    putstring(b)
    n = n - 1
  end
end

fibonaccit( 10 )
