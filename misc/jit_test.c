#include "header.h"

int main (int argc, char *argv[]) {
    char asmFunc[] = {0x90, 0xB8, 0x10, 0x00, 0x00, 0x00, 0xC3};
    /*
     nop
     mov $16, eax
     ret
     */
    
    void *fup = mmap(NULL, sizeof(asmFunc), PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0); //let kernel choose page, writeable and executable, akin to malloc, -1 and 0 are not used, there for stability
    //another possiblity is to use mprotect() on a malloc'ed call to make it executable
    memcpy(fup, asmFunc, sizeof(asmFunc));
    
    int (*func)() = fup;
    printf("%d\n", (*func)());

    
}


