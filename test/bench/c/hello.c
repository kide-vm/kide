#include<stdio.h>

int main(void)
{
  setbuf(stdout, NULL); /* to make it equivalent to the other versions, otherwise it caches */
  int counter = 100000;
	while(counter--) {
    printf("Hello there\n");
	}
}
