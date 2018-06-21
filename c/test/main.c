#include "header.h"

int main(int argc, char **argv) {
	int arr[10];
	int arr2[arr[2]];
	
	arr2[0] = 1;
	return arr2[1];
}
