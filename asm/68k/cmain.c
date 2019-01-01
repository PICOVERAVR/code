// cannot link to libc since we haven't compiled and linked it in yet
// so everything has to be bare-metal

int addone(int x) {
	return x+1;
}

int main() {
	int x = 4;
	x = addone(x);
}

void _start() {
	main();
	hang: goto hang;
}
