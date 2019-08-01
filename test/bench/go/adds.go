package main

func fibo(n int ) int {

  result := 0
   a := 0
   b := 1
   i := 1

  for( i < n ) {
      result = a + b;
      a = b;
      b = result;
      i++;
  }
	return result
}

func main() {
  sum := 1
  res := 0
  for sum < 50000 {
    sum += 1
    res = fibo( 40 )
  }
  res += 1
}
