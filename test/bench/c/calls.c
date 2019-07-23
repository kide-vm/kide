#include<stdio.h>

int fibo_r(int n)
{
   if ( n <  2 )
      return n;
   else
      return ( fibo_r(n-1) + fibo_r(n-2) );
}

int main(void)
{
	int counter = 100000;
	int fib ;
	while(counter--) {
		fib += fibo_r(10);
	}
}
