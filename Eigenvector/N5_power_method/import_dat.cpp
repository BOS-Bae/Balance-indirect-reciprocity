#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

int main() {
    std::ifstream file("N4_permute.dat");
    std::string line;

    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::vector<int> elements;

        int num;
        while (iss >> num) {
            elements.push_back(num);
        }

        // Now 'elements' contains the elements of the current line
        // You can process these elements as needed
        for (int element : elements) {
            std::cout << element << " ";
        }
        std::cout << std::endl;
    }

    return 0;
}

