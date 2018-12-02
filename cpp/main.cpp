#include <iostream>
using namespace std;

class base {
    public:
    virtual void f() { std::cout << "Base function!" << std::endl; }
};

class d1: public base {
    public:
    void f() { std::cout << "Derived 1 function!" << std::endl; }
};

class d2: public base {
    public:
    void f() { std::cout << "Derived 2 function!" << std::endl; }
};

int main(int argc, char **argv) {
	
	int c = 4;
	auto sum = [c] (auto a, int b) -> double { // jesus
		return a * b + c;
	};
	
	cout << sum(4, 3) << endl;
	
}
