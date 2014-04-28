def fibonaccir( n , put )
    return  n  if n <= 1 
    res = fibonaccir( n - 1 , put ) + fibonaccir( n - 2 , false )
    puts(res) if put
    res
end 

fibonaccir( 10 , true)
