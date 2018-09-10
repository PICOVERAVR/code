#include "header.h"
#include <stdint.h>
#include <string.h>

int main() {
	uint8_t code[] = {0xb8, 0x00, 0x00, 0x00, 0x00, 0xc3};
	void *mem = mmap(NULL, sizeof(code), PROT_WRITE | PROT_EXEC, MAP_ANON | MAP_PRIVATE, -1, 0);
	memcpy(mem, code, sizeof(code));
	
	int (*func)() = mem;
	
	int x = func();
	
	/*
		
		
		
	*/
}
