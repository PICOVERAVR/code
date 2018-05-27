#include "mcc_generated_files/mcc.h"

void main(void) {
    SYSTEM_Initialize();
    
    __delay_ms(1);
    printf("Aux Ready.\n");
    for(;;) {
        __delay_ms(1);
        adc_result_t res = ADC1_GetConversion(channel_AN2);
        printf("A%x\n", res);
    }
}