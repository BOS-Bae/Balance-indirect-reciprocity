#include <iostream>
#include <cstdlib>
#include <vector>
#include <array>
#include <map>
#include <chrono>
#include "Configuration.hpp"

constexpr int N = 4;
const size_t NN = 1 << (N*N);

int main() {
	std::cout << (double)1/NN << "\n";
	return 0;
}
