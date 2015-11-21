#include<stdio.h>

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
	int counter = 100352 - 352;
	int counter2 = counter;
	int level = 40;
	int fib ;
	while(counter--) {
		fib = fibo(level);
	}
}
