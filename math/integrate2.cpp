// clang: clang++ main.cpp -Ofast -ffast-math -std=c++17 -o main.out
// gcc: g++ main.cpp -Ofast -ffast-math -avx2 -pthread -std=c++17 -o main.out
#include <iostream>
#include <limits>
#include <future>

// function to approximate
double func(double x, double y) {
	return 2.0 - ( x*x + y*y );
}

// basic method of approximation, using double riemann sums.
// there are more advanced algorithms out there that get better results, are probably faster too
double i2add(double xmin, double xmax, double ymin, double ymax, int xnum, int ynum) {
	
	const double dx = (xmax - xmin) / xnum;
	const double dy = (ymax - ymin) / ynum;
	
	double sum = 0.0;
	
	for (double x = xmin; x < xmax; x += dx) {
		for (double y = ymin; y < ymax; y += dy) {
			sum += func(x + dx/2, y + dy/2);
		}
	}

	return sum * dx * dy;
}

int main(int argc, char **argv) {
	
	const double xmin = 0.0;
	const double xmax = 1.0;
	
	const double ymin = 0.0;
	const double ymax = 1.0;

	const int size = 2<<17;

	double sum = 0.0;
	
	const int num_threads = std::thread::hardware_concurrency();
	
	const double xstep = (xmax - xmin) / num_threads;
	
	std::cout << "Integrating a function from " << xmin << " to " << xmax << " (x) and from " << ymin << " to " << ymax << " (y), " << (long)size << " samples per dimension." << std::endl;
	std::cout << "Using " << num_threads << " threads." << std::endl;
	
	std::future<double> threadarr[num_threads];
	for (int i = 0; i < num_threads; i++) {
		threadarr[i] = std::async(i2add, xmin + xstep * i, xmin + xstep * (i + 1), ymin, ymax, size / num_threads, size);
	}
	
	for (int i = 0; i < num_threads; i++) {
		sum += threadarr[i].get();
	}
	
	//double sumser = i2add(xmin, xmax, ymin, ymax, size, size);
	
	std::cout.precision(std::numeric_limits<double>::max_digits10); // print full numeric precision to see errors
	std::cout << "Parallel answer: " << sum << std::endl;
	
	//std::cout << "Serial answer: " << sumser << std::endl;
}
