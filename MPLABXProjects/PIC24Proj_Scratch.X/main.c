#include "header.h"
#include "sd.h"
#include "tft.h"

int main(void) {
    SYSTEM_Initialize();
    
    printf("system ready.\n");
    
    printf("initializing sd card... ");
    printf((!sd_init()) ? "success.\n" : "fail.\n");
    
    printf("initializing tft display... ");
    tft_init();
    printf("done.\n");
    
    sd_block mbr;
    sd_block_addr mbr_addr = {0};
    sd_readBlock(mbr_addr, &mbr);
    
    sd_block vbr;
    sd_block_addr vbr_addr;
    for (int i = 0; i < 4; i++) {
        vbr_addr.byte[i] = mbr.data[0x1C6 + i];
    }
    sd_readBlock(vbr_addr, &vbr);
    
    sd_block fat;
    sd_block_addr fat_addr = {0};
    fat_addr.byte[0] = vbr.data[0x0E];
    fat_addr.byte[1] = vbr.data[0x0F];
    
    fat_addr.uint = fat_addr.uint + vbr_addr.uint;
    sd_readBlock(fat_addr, &fat);
    
    sd_block root;
    sd_block_addr root_addr = {0};
    root_addr.byte[0] = vbr.data[0x24];
    root_addr.byte[1] = vbr.data[0x25];
    root_addr.byte[2] = vbr.data[0x26];
    root_addr.byte[3] = vbr.data[0x27];
    
    root_addr.uint *= 2;
    root_addr.uint = root_addr.uint + fat_addr.uint;
    
    sd_readBlock(root_addr, &root);
    
    sd_printBlock(&fat);
    printf("\n\n");
    sd_printBlock(&root);

    for(;;) {
        
        
        
        
    }
    return -1;
}
