#include "header.h"
using namespace std;

int main(int argc, char **argv) {
	
	int *heap = new int[4096]; //for kicks
	assert(heap); //check for allocation error
	
	
	
	delete [] heap;
	return 0;
}
