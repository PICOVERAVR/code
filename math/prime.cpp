#include <iostream>
#include <vector>

using namespace std;

// set all positions in the array that are prime to true
// array is initially all true
long int findPrimes(vector<bool> &prime_list, const long long n) {
	long int p = 2; // smallest prime
	long int num_primes = 0;

	bool more;
	
	prime_list[0] = false;
	prime_list[1] = false; // not prime

	while (more) {
		more = false;
		
		// mark everything from 2p to n
		for (long int discard = p * p; discard < n; discard += p) {
			prime_list[discard] = false;
		}
		
		for (long int nextp = p + 1; nextp < n; nextp++) {
			if (prime_list[nextp]) {
				p = nextp;
				more = true;
				num_primes++;
				break;
			}
		}
		
		if (!more) {
			return num_primes;
		}
	}
	return -1;
}

int main(int argc, char **argv) {
	
	unsigned long long end_num = 1 << 27;
	cout << "finding primes from 0 to " << end_num << "." << endl;
	vector<bool> prime_list;
	
	for (int i = 0; i < end_num - 2; i++) {
		prime_list.push_back(true);
	}
	
	long int nump = findPrimes(prime_list, end_num);
	
	cout << "Found " << nump << " primes." << endl;
}
