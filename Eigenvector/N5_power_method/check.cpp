#include <iostream>
#include <cstdlib>
#include <vector>
#include <fstream>
#include <array>
#include <map>
#include <cmath>
#include <algorithm>
#include <chrono>
#include "Configuration.hpp"

constexpr int N = 5;

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

void balanced_idx(std::vector<unsigned long long> &bal_list) {
  const size_t max_idx = (1ull << N) - 1;
  std::vector<std::array<int, N> > id_mat(max_idx);
  for (int i = 0; i < max_idx; i++) {
    int idx = i;
    for (int j = 0; j < N; j++) {
      int id = idx & 1;
      id_mat[i][j] = id;
      idx = idx >> 1;
    }
  }
  int max_num = 0;
  for (int i = 0; i < max_idx; i++) {
    int mat[N][N] = {0,};
    for (int x = 0; x < N; x++) {
      for (int y = 0; y < N; y++) {
        if (id_mat[i][x] == id_mat[i][y]) mat[x][y] = mat[y][x] = 1;
        else mat[x][y] = mat[y][x] = -1;
      }
    }
    unsigned long long bal_idx = mat_to_idx(mat);
    if (i == 0) {
      bal_list.push_back(bal_idx);
      max_num += 1;
    } else {
      int check = 0;
      int different = 0;
      for (int k = 0; k < max_num; k++) {
        check += 1;
        if (bal_list[k] != bal_idx) different += 1;
      }
      if (check == different) {
        bal_list.push_back(bal_idx);
        max_num += 1;
      }
    }
  }
}

int main() {
	std::vector<unsigned long long> bal_list = {};
	balanced_idx(bal_list);

	std::vector<std::vector<std::vector<int>>> bal_mat = {
		{{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1}},
		{{1,-1,-1,-1,-1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1}},
		{{1,-1,-1,-1,-1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1}},
		{{1,1,-1,-1,-1},{1,1,-1,-1,-1},{-1,-1,1,1,1},{-1,-1,1,1,1},{-1,-1,1,1,1}},
		{{1,1,-1,-1,-1},{1,1,-1,-1,-1},{-1,-1,1,1,1},{-1,-1,1,1,1},{-1,-1,1,1,1}}};

	 bal_mat[0][0][1] *= -1; // 0:5 | p -> n 
	 bal_mat[1][0][1] *= -1; // 1:4 | n -> p
	 bal_mat[2][1][2] *= -1; // 1:4 | p -> n
	 bal_mat[3][2][0] *= -1; // 2:3 | n -> p
	 bal_mat[4][0][1] *= -1; // 2:3 | p -> n
	int mat[N][N];
	for (int k=0; k<5; k++){
		std::vector<std::vector<int>> bal_arr = bal_mat[k];
		for (int i = 0; i < N; i++) {
			for (int j = 0; j < N; j++){
				mat[i][j] = bal_arr[i][j];
			}
		}
		int idx = mat_to_idx(mat);
		std::cout << idx <<" ";
	}
//	std::cout << "\n";
//	int num_of_bal = 1 << (N-1);
//	for (int k=0; k<num_of_bal; k++) std::cout << bal_list[k] << "\n";
	return 0;
}
