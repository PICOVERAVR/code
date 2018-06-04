#include "header.h"
#include "oled.h"

char spaceship[] = {0xFF, 0x18, 0x7E, 0x81, 0x81}; //spaceship character

void drawthing(int oldr, int newr, int start, int end, char pattern[]) {
    if (newr != oldr) {
        oled_setbox(oldr, oldr, start, end);
        for (int i = 0; i <= end; i++) {
            oled_data(0x00);
        }
        oled_setbox(newr, newr, start, end);
        
        for (int i = 0; i < strlen(pattern); i++) { //breaks if pattern contains 0x00, obviously
            oled_data(pattern[i]);
        }
    }
}

int main(void) {
    SYSTEM_Initialize();
    IEC0bits.AD1IE = 0;
    i2c_init(I2C_100K);
    oled_init();
    //init heap in config options before malloc'ing stuff
    
	printf("%x, Ready.\n", RCON);
    RCON = 0;
    
    int prev = 0;
    
    for(;;) {
        int ypos = adc_convert();
        int row = map(ypos, 0, 4095, 0, 8);
        
        if (row == 8) row = 7; //map gets weird at 8, not linear anymore
        
        drawthing(prev, row, 55, 60, spaceship);
        
        prev = row;
        
        //halt();
    }
    return -1;
}