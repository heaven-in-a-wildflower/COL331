#include "types.h"
#include "stat.h"
#include "user.h"

int fib(int n){
	if (n <= 0) return 0;
	if (n == 1) return 1;
	if (n == 2) return 1;
	return fib(n - 1) + fib(n - 2);
}

void sv(){
	printf(1 , "I am Shivam\n" );
}

void myHandler(){
	sv();
	printf(1 , "I am inside the handler\n" );
}

int main(){
	signal(myHandler);
	while(1){
		printf (1 , "This is normal code running\n" );
		fib(35);
	}
}