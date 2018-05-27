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
        uint16_t xPosRaw = adc_convert(0);
        long xPos = map(xPosRaw, 0, 1023, 320, 0);
        ltoa(buf_x, xPos, 10);
        tft_blank(17, 0, 15);
        tft_str(17, 0, buf_x);
        
        
    }
    return -1;
}