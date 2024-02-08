#include <iostream>
#include <cmath>
#include <cstdlib>
#include <vector>
#include <array>
#include <map>
#include <chrono>
#include "Configuration.hpp"

constexpr int N = 4;
const size_t NN = 1 << (N*N);
const size_t Nbal = 1 << (N-1);

unsigned long long mat_to_idx(int mat[][N]) {
  unsigned long long idx = 0, binary_num = 0;
  idx = binary_num = 0;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      int element = ((int) (mat[N - i - 1][N - j - 1] + 1) / 2);
      idx += element * (int) pow(2, binary_num);
      binary_num += 1;
    }
  }
  return idx;
}

void idx_to_mat(unsigned long long idx, int mat[][N]) {
  for (int i = 0; i < N; i++) {
    int slice_row = N * (N - 1 - i);
    for (int j = 0; j < N; j++) {
      int slice_col = N - j - 1;
      int M_ij = idx >> slice_row >> slice_col & 1;  // [TODO] check this line
      mat[i][j] = 2 * M_ij - 1;
    }
  }
}

int main() {
	std::vector<int> flip_list = {34167, 35891, 49151, 51063, 52787};
	for (int i = 0; i < 5; i++){
		int mat[N][N] = {0,};
		int idx = flip_list[i];
		idx_to_mat(idx, mat);
		for (int j = 0; j < N; j++){
			for (int k = 0; k < N; k++){
				std::cout << mat[j][k] << " ";
			}
			std::cout << "\n";
		}
		std::cout << "\n";
	}
	return 0;
}
