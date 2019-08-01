#include<stdio.h>

int main(void)
{
  setbuf(stdout, NULL); /* to make it equivalent to the other versions, otherwise it caches */
  int counter = 10000;
	while(counter--) {
    printf("Hello there\n");
	}
}
