def fibonacci_t(n)
  a,b = 0,1
  n.times do
    printf("%d\n", a)
    a,b = b,a+b
  end
end

puts fibonacci_t( 10 )
