#include "header.h"
#include "tft.h"
#include "sd.h"

int main(void) {
    SYSTEM_Initialize();
    tft_init();
    tft_fillScreen(TFT_COLOR_BLACK);
    
	printf("%x, Ready.\n", RCON);
    RCON = 0;
    
    
    for(;;) {
        
        
        
        
    }
    return -1;
}
