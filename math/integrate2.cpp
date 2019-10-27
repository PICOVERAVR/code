// compile with clang++ main.cpp -Ofast -ffast-math -avx2 -o main.out
#include <iostream>
#include <limits>

struct ends {
	double xmin;
	double xmax;
	
	double ymin;
	double ymax;
	
	int xnum;
	int ynum;

};

// function to approximate
double func(double x, double y) {
	return 2.0 - ( x*x + y*y );
}

// basic method of approximation, using double riemann sums.
// there are more advanced algorithms out there that get better results, are probably faster too
double i2add(double (*f)(double, double), ends p) {
	
	const double dx = (p.xmax - p.xmin) / p.xnum;
	const double dy = (p.ymax - p.ymin) / p.ynum;
	
	double sum = 0.0;
	
	for (double x = p.xmin; x < p.xmax; x += dx) {
		for (double y = p.ymin; y < p.ymax; y += dy) {
			sum += f(x + dx/2, y + dy/2);
		}
	}

	return sum * dx * dy;
}

int main(int argc, char **argv) {
	
	const double xmin = 0.0;
	const double xmax = 1.0;
	
	const double ymin = 0.0;
	const double ymax = 1.0;

	const int size = 2<<15;

	double sum = 0.0;
	
	std::cout << "Integrating a function from " << xmin << " to " << xmax << " (x) and from " << ymin << " to " << ymax << " (y), " << (long)size << " samples per dimension" << std::endl;

	const ends temp = { xmin, xmax, ymin, ymax, size, size };
	sum = i2add(func, temp);
	
	std::cout.precision(std::numeric_limits<double>::max_digits10); // print full numeric precision to see errors
	std::cout << "Answer: " << sum << std::endl;
}
