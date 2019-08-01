def fibo( n)
	 a = 0
	 b = 1
	 i = 1
  while( i < n ) do
    result = a + b
    a = b
    b = result
    i+= 1
  end
	return result
end

 counter = 50000

while(counter > 0) do
	fibo(40)
  counter -= 1
end
