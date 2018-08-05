#include "header.h"
#include "fat.h"

int main(void) {
    SYSTEM_Initialize();
    
    printf("System ready.\n");
    if (fat_init()) {
        printf("ERROR: FAT32 init failed!");
        halt();
    }
    fat_open("TEST.TXT");
    
    halt();
    
    return -1;
}