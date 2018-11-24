#include <iostream>

#pragma once

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

