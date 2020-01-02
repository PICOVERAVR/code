#include <iostream>

#pragma once

class base {
	public:
	void base_f() { std::cout << "Base function!" << std::endl; }
};

class d1: public base {
	public:
	void d1_f() { std::cout << "Derived 1 function!" << std::endl; }
};

class d2: public base {
	public:
	void d2_f() { std::cout << "Derived 2 function!" << std::endl; }
};

