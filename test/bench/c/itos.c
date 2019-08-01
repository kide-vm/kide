#include<stdio.h>

int main(void)
{
	char stringa[20] ;
	int counter = 1000;
	while(counter--) {
		sprintf(stringa, "%i\n" , counter);
	}

}
