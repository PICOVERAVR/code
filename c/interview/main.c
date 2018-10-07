#include <stdio.h>

int main() {
	printf("Fib Program\n");
	
	int current = 1;
	int prev = 0;
	
	// 0 1 1 2 3 5 8 13
	for (int i = 0; i < 20; i++) {
		printf("Current value is: %d\n", current);
		
		int temp = current;
		current = current + prev;
		prev = temp;
	}
}
