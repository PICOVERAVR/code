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
    
    sd_block_addr s = {0};
    
    sd_block mbr, vbr;
    sd_readBlock(s, &mbr);
    
    for (int i = 0; i < 4; i++) {
        s.byte[i] = mbr.data[0x1C6 + i];
    }
    
    //s.byte[1] = 0x20; //this is little-endian!
    sd_readBlock(s, &vbr);
    for (int i = 0; i < 512; i++) {
        printf("%d %x\t", i, vbr.data[i]);
    }
//    for (int i = 1; i <= 32; i++) {
//        for (int j = 1; j <= 16; j++) {
//            printf("%x, ", vbr.data[i * j]);
//        }
//        printf("\n");
//    }
    
    for(;;) {
        
        
        
        
    }
    return -1;
}
