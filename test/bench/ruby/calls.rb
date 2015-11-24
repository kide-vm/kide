
def fibo_r( n )
   if( n <  2 )
      return n
   else
      return fibo_r(n - 1) + fibo_r(n - 2)
   end
end


 counter = 1000

 while(counter > 0) do
   fibo_r(20)
   counter -= 1
 end
