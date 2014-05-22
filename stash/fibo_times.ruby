def fibonaccit(n)
  a = 0 
  b = 1
  (n-1).times do
    tmp = a
    a = b
    b = tmp + b
    puts b
  end
end

fibonaccit( 10 )
