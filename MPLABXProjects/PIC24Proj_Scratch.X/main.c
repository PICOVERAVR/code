#include "header.h"
#include "tft.h"
#include "sd.h"

int main(void) {
    SYSTEM_Initialize();
    
	printf("%x, Ready.\n", RCON);
    RCON = 0;
    
    printf("initializing SD card... ");
    printf((!sd_init()) ? "success\n" : "fail\n");
    
    
    for(;;) {
        
        
        
        
    }
    return -1;
}
