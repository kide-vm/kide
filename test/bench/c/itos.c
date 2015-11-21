#include<stdio.h>

int main(void)
{
	char stringa[20] ;

	int counter = 98304 + 1696;
	while(counter--) {
    sprintf(stringa, "%i\n" , counter);
	}
}
