#include "header.h"
#include "fat.h"

int main(void) {
    SYSTEM_Initialize();
    
    printf("Hello.\n");
    
    
    halt();
    
    return -1;
}