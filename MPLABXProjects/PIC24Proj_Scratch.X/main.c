#include "header.h"
#include "tft.h"
#include "sd.h"

int main(void) {
    SYSTEM_Initialize();
    //tft_init();
    //tft_fillScreen(TFT_COLOR_BLACK);
    
	printf("%x, Ready.\n", RCON);
    RCON = 0;
    printf("sd card initializing... ");
    int res = sd_init();
    printf((res) ? "fail\n" : "success\n");
    
    
    
    for(;;) {
        
        
        
        
    }
    return -1;
}
