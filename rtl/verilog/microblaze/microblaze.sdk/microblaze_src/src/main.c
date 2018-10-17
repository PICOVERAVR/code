#include "xgpio.h" // GPIO driver

#include "xparameters.h" // info about AXI peripherals

int main() {
	XGpio gpio;
	u32 led;

	XGpio_Initialize(&gpio, 0);

	XGpio_SetDataDirection(&gpio, 2, 0x00000000);

	led = 0xFFFFFFFF;
	XGpio_DiscreteWrite(&gpio, 2, led);

	for(;;) {
		;
	}
}
