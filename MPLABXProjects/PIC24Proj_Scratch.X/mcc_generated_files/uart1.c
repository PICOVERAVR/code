#include "uart1.h"

void UART1_Initialize(void) {
/**    
     Set the UART1 module to the options selected in the user interface.
     Make sure to set LAT bit corresponding to TxPin as high before UART initialization
*/
    // STSEL 1; IREN disabled; PDSEL 8N; UARTEN enabled; RTSMD disabled; USIDL disabled; WAKE disabled; ABAUD disabled; LPBACK disabled; BRGH enabled; URXINV disabled; UEN TX_RX; 
    U1MODE = (0x8008 & ~(1<<15));  // disabling UARTEN bit   
    // UTXISEL0 TX_ONE_CHAR; UTXINV disabled; OERR NO_ERROR_cleared; URXISEL RX_ONE_CHAR; UTXBRK COMPLETED; UTXEN disabled; ADDEN disabled; 
    U1STA = 0x0000;
    // BaudRate = 9600; Frequency = 16006718 Hz; BRG 416; 
    U1BRG = 0x01A0;
    
    U1MODEbits.UARTEN = 1;  // enabling UARTEN bit
    U1STAbits.UTXEN = 1; 
   
}

uint8_t UART1_Read(void) {
    while(!(U1STAbits.URXDA == 1));
    
    if ((U1STAbits.OERR == 1)) {
        U1STAbits.OERR = 0;
    }
    return U1RXREG;
}

void UART1_Write(uint8_t txData) {
    while(U1STAbits.UTXBF == 1);

    U1TXREG = txData;    // Write the data byte to the USART.
}

UART1_STATUS UART1_StatusGet(void) {
    return U1STA;
}

int __attribute__((__section__(".libc.write"))) write(int handle, void *buffer, unsigned int len) {
    int i;
    while(U1STAbits.TRMT == 0);  
    for (i = len; i; --i)
    {
        while(U1STAbits.TRMT == 0);
        U1TXREG = *(char*)buffer++;        
    }
    return(len);
}
