#include "main.h"

std::atomic<int> val(0);

void get() {
	std::cout << "value is " << val.load(std::memory_order_relaxed) << std::endl; 
}

void set(int x) {
	std::cout << "storing value " << x << std::endl;
	val.store(x, std::memory_order_relaxed);
}

int main(int argc, char **argv) {
	std::cout << "threading example - " << std::thread::hardware_concurrency() << " threads available." << std::endl;
	
	std::thread t(set, 4);
	std::thread t2(set, 6);

	std::thread t3(get);
	
	t.join();
	t2.join();
	t3.join();

	return 0;
}
