int fibo(int n){
  int result;
	int a = 0;
	int b = 1;
	int i = 1;
  while( i < n )
  {
      result = a + b;
      a = b;
      b = result;
      i++;
  }
	return result;
}

int main(void)
{
  int counter = 50000;
	int fib ;
	while(counter) {
		fib = fibo(40);
    counter -= 1;
	}
}
