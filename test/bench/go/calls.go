package main

func fib(n uint) uint {
  if n < 2 {
      return n
	} else {
		return fib(n-1) + fib(n-2)
	}
}

func main() {
  sum := 1
  for sum < 100 {
    sum += 1
    fib( 20 )
  }
}
