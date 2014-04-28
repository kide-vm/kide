def fibonacci_r( n )
    return  n  if n <= 1 
    fibonacci_r( n - 1 ) + fibonacci_r( n - 2 )
end 

puts fibonacci( 10 )
