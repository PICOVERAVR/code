#include "header.h"
#include "tft.h"

int main(void) {
    SYSTEM_Initialize();
    tft_init();
    tft_fillScreen(TFT_COLOR_BLACK);
    
	printf("%x, Ready.\n", RCON);
    RCON = 0;
    
    asm("nop");
    tft_str(0, 0, "TFT test screen");
    char buf_x[15];
    
    for(;;) {
        //menu items here idk
        
        
        
    }
    return -1;
}