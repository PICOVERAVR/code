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
    
    sd_block mbr, vbr;
    sd_readBlock(0, &mbr);
    
    if (mbr.data[511] != 0xAA || mbr.data[510] != 0x55) {
        printf("mbr not present!");
    } else {
        
        uint64_t addr = 0;
        for (int i = 4; i > 0; i--) {
            
        }
        
        
        sd_readBlock(mbr.data[454] * 0x200, &vbr);
    }
    
    for(;;) {
        
        
        
        
    }
    return -1;
}
