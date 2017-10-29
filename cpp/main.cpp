#include "header.h"
using namespace std;

int func (int x, int y) {
	return x / 2;
}

int main(int argc, char **argv) {
	
	int *heap = new int[4096]; //for kicks
	assert(heap); //check for allocation error
	
	cout << func(6, 7) << endl;


	
	delete [] heap;
	return 0;
}
