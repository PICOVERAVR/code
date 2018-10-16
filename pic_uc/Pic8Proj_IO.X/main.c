#include "header.h"

//boilerplate to read the keypad and output it.
//this microcontroller is really excessive but I hope to use it as a low-speed IO controller
void main() {
    setup();
    uart_setup(9600);
    uart_print("Ready.\n");
    
    for(;;) {
        
    }
}