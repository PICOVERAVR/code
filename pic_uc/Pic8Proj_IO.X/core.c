#include "header.h"

//misc bit setup functions, not essential to know
void setup() {
    OSCCONbits.IRCF0 = 1;
    OSCCONbits.IRCF1 = 1; //set 8MHz clock freq
    OSCCONbits.IRCF2 = 1;
    
    OSCTUNEbits.PLLEN = 1; //turn on 4x PLL
    
    OSCCONbits.SCS1 = 1; //set system clock to internal osc
    
    PORTAbits.AN0 = 0; // turn off analog functionality
    TRISAbits.TRISA0 = 0; //configure as output
    PORTAbits.RA0 = 1; //turn on port   
}

void uart_setup(unsigned int baud) {
    RCSTAbits.SPEN = 1;
    TRISCbits.TRISC7 = 1;
    TRISCbits.TRISC6 = 0; //configure pins
    
    //set baudrate
    TXSTAbits.BRGH = 1; //"high speed"
    BAUDCONbits.BRG16 = 0; //only SPBRG (8-bit)
    //SPBRG = (_XTAL_FREQ / (16 * baud)) - 1; //calculate BRG value from datasheet equation
    SPBRG = 51;
    
    TXSTAbits.SYNC = 0; //async uart
    
    PIE1bits.TXIE = 0; //no interrupts used
    
    TXSTAbits.TXEN = 1; //enable xmit
    RCSTAbits.CREN = 1; //enable recv
    RCSTAbits.SPEN = 1; //enable UART
}

void uart_send(char c) { //send a char
    TXREG = c;
    while(!TXSTAbits.TRMT); //wait for char to finish sending
}

//uart_recv()

void uart_print(const char *c) { //print a string
    for (unsigned int i = 0; i < strlen(c); i++) {
        uart_send(c[i]);
    }
}

inline void uart_printd(uint16_t d, int b) { //print d in base b
    char buf[24]; //enough to hold a double probably
    itoa(buf, d, b);
    uart_print(buf);
}

