#include<stdio.h>

int main(void)
{
	setbuf(stdout, NULL); /* to make it equivalent to the typed version, otherwise it caches */
	int counter = 100352 - 352;
	while(counter--) {
    printf("Hello there\n");
	}
}
