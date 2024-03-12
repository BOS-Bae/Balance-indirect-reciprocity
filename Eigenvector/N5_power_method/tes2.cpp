#include <iostream>
#include <vector>

void generatePermutations(std::vector<std::vector<int>>& permutations, std::vector<int>& current, std::vector<bool>& chosen) {
    if (current.size() == chosen.size()) {
        permutations.push_back(current);
        // Print current permutation
        //std::cout << "Current permutation: ";
        //for (int i = 0; i < current.size(); i++) {
        //    std::cout << current[i] << " ";
        //}
        //std::cout << std::endl;
        return;
    }
    std::cout << "Current permutation: ";
    for (int i = 0; i < current.size(); i++) {
        std::cout << current[i] << " ";
    }
    std::cout << std::endl;
    for (int i = 0; i < chosen.size(); i++) {
        if (!chosen[i]) {
            chosen[i] = true;
            current.push_back(i);
            generatePermutations(permutations, current, chosen);
            current.pop_back();
            chosen[i] = false;
        }
    }
}

int main() {
    int N = 4; // Number of nodes
    std::vector<std::vector<int>> permutations;
    std::vector<int> current;
    std::vector<bool> chosen(N, false);
    generatePermutations(permutations, current, chosen);

    return 0;
}

