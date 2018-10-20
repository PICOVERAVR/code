#include "xgpio.h"
#include "xil_printf.h"

#include "xparameters.h"

int main() {
	XGpio gpio;
	u32 btn, led;

	XGpio_Initialize(&gpio, 0);

	XGpio_SetDataDirection(&gpio, 2, 0x00000000);
	XGpio_SetDataDirection(&gpio, 1, 0xFFFFFFFF);

	for (;;) {

		btn = XGpio_DiscreteRead(&gpio, 1);
		XGpio_DiscreteWrite(&gpio, 2, led);

		xil_printf("Hello world from MicroBlaze!!\n");

	}
}
