#include "header.h"
using namespace std;

int main(int argc, char **argv) {
	//int *heap = new int[4096]; //for kicks
	d1 d;
	d2 d_2;
	base *b, *b2;
	
	b = &d;
	b2 = &d_2;
	
	b->f();
	b2->f();
	
	//delete [] heap;
	return 0;
}
