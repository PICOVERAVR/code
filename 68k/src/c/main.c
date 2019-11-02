int x = 0xF00F;
int y;

void delay(int value) { // value in ms
	const int delaycycles = (value * 1000) / 22;
	volatile int current = 0;
	while (current++ < delaycycles);
}

int main() {
	delay(100);
	return 0;
}
