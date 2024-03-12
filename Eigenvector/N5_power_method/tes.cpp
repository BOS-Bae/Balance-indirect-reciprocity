#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <array>
#include <algorithm>

constexpr int N = 5;

// The reason for using 'usigned long long' : 2^(N*N) exceeds the maximum of 'int', when N=6.
void idx_to_mat(unsigned long long idx, int mat[][N]);

void print_mat(int mat[][N]);

unsigned long long mat_to_idx(int mat[][N]);

void balanced_idx(std::vector<unsigned long long> &bal_list);

void L4_rule(int mat_f[][N], int o, int d, int r, int idx_err);

void L6_rule(int mat_f[][N], int o, int d, int r, int idx_err);

void n_list_gen(int n_num, int n_list[][N]);

void power_method(double err, int max_iter, int rule_num, int flip_idx);

/*
	init_vect_idx = 0 : r_i has elments with uniform values (=1/num_matrix)
	init_vect_idx = 1 : r_i has an element for a balanced index only
	init_vect_idx = 2 : r_i has an element for a balanced index only
	
	init_vect_idx = 0 : 2^(N*N) elements in dat file (whole possible states)
	init_vect_idx = 1 : 2^(N-1) elements in dat file (only balanced states)
	init_vect_idx = 2 : 2^(N-1) elements in dat file (only balanced states)
*/
int main() {
  int mat[N][N] = {0,};
	//std::vector<unsigned long long> vec = {1, 32, 128, 512};
	//std::vector<unsigned long long> vec = {4078, 4062, 4030, 3582, 4085, 3965, 3837, 3581, 4083, 4027, 3067 ,2043 ,3959, 3063, 4015 ,3823, 3055, 3935, 3551, 2015, 1983, 1919 ,3327, 2815};
	
//std::vector<unsigned long long> vec = {523127, 523263, 1048439};
std::vector<unsigned long long> vec = {822289};
	for (int i = 0; i < vec.size(); i++){
		std::cout << vec[i] << " : ";
		idx_to_mat(vec[i], mat);
		print_mat(mat);
	}
	return 0;
}

void print_mat(int mat[][N]){
	for (int j=0; j<N; j++){
		for (int k=0; k<N; k++){
			std::cout << mat[j][k] << " ";
		}
		std::cout << "; ";
	}
	std::cout << "\n";
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
    } 
		else {
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


void idx_to_mat(unsigned long long idx, int mat[][N]) {
	int idx_tmp = idx;
  for (int i = 0; i < N; i++) {
		mat[i][i] = 1;
    for (int j = 0; j < N; j++) {
			if (i!=j){
      	int M_ij = idx_tmp & 1;  // [TODO] check this line
      	mat[i][j] = 2 * M_ij - 1;
				idx_tmp = idx_tmp >> 1;
			}
    }
  }
}

unsigned long long mat_to_idx(int mat[][N]) {
  unsigned long long idx = 0, binary_num = 0;
  idx = binary_num = 0;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
			if (i!=j){
      	int element = ((int) (mat[i][j] + 1) / 2);
      	idx += element * (int) pow(2, binary_num);
      	binary_num += 1;
			}
    }
  }
  return idx;
}

void n_list_gen(int n_num, int n_list[][N]) {
  for (int i = 0; i < n_num; i++) {
    // The number of possible configurations of assessment eror is n_num.
    int val = i;
    for (int j = 0; j < N; j++) {
      n_list[i][j] = val & 1;
      val = val >> 1;
    }
  }
}

void L4_rule(int mat_f[][N], int o, int d, int r, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  int val = mat_f[o][d];
  if (mat_f[d][r] == 1) {
    if (mat_f[o][d] == -1)
      val = mat_f[o][r];
  } else
    val = -mat_f[o][r];

  mat_f[o][d] = idx_err == 0 ? val : -val;
}

void L6_rule(int mat_f[][N], int o, int d, int r, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  mat_f[o][d] = (idx_err == 0 ? mat_f[o][r] * mat_f[d][r] : -mat_f[o][r] * mat_f[d][r]);
}


void power_method(double err, int max_iter, int rule_num, int flip_idx) {
  /*
    init_vect_idx = 0 : r_i has elments with uniform values (=1/num_matrix)
    init_vect_idx = 1 : r_i has an element for a balanced index only
    init_vect_idx = 2 : r_i has an element for a balanced index only

    init_vect_idx = 0 : 2^(N*N) elements in dat file (whole possible states)
    init_vect_idx = 1 : 2^(N-1) elements in dat file (only balanced states)
    init_vect_idx = 2 : 2^(N-1) elements in dat file (only balanced states)
  */
  constexpr int n_num = 1 << N;
  double array[2];
  array[0] = (1.0 - err);
  array[1] = err;

  int num_of_bal = (int) pow(2, N - 1);
  std::vector<unsigned long long> bal_list = {};
  balanced_idx(bal_list);
  sort(bal_list.begin(), bal_list.end());

  int n_list[n_num][N];
  double prob_mul;
  n_list_gen(n_num, n_list);

  const size_t num_matrix = 1ull << (N * (N-1));
  std::ofstream opening;
  
	char result[100];
  sprintf(result, "./network_flip/N%dL%d_flip%d.dat", N, rule_num, flip_idx);
  opening.open(result);
	std::vector<unsigned long long> flip_list_N5 = {846865, 838737, 822289, 838657};
  unsigned long long flip_elem = flip_list_N5[flip_idx];
	
	std::vector<unsigned long long> s_i = {};
	std::vector<unsigned long long> s_f = {};
  // measure elapsed time
  std::vector<double> r_i(num_matrix, 0.0);
	r_i[flip_elem] = 1;
	int chk = 0;
  for (int t = 0; t < max_iter; t++) {
		s_i.clear();
		int len_f = s_f.size();
		if (t==0) s_i.push_back(flip_elem);
		else {
			for (int i = 0 ; i < len_f; i++) s_i.push_back(s_f[i]);
		}
		s_f.clear();
		int len = s_i.size();
    std::vector<double> r_f(num_matrix, 0.0);
    for (int i = 0; i < num_matrix; i++) {
      int mat_i[N][N] = {0,};
      int mat_f[N][N] = {0,};
      idx_to_mat(i, mat_i);
      for (int x = 0; x < N; x++) {
        for (int y = 0; y < N; y++) {
          for (int m = 0; m < n_num; m++) {
            std::copy(&mat_i[0][0], &mat_i[0][0] + N * N, &mat_f[0][0]);
            prob_mul = 1.0;
            for (int l = 0; l < N; l++) {
              int idx_n = n_list[m][l];
              switch (rule_num) {
                case 4 :
                  L4_rule(mat_f, l, x, y, idx_n);
                  break;
                case 6 :
                  L6_rule(mat_f, l, x, y, idx_n);
                  break;
              }
              prob_mul *= array[idx_n];
           } 
           int idx_f = mat_to_idx(mat_f);
       	  	r_f[idx_f] += prob_mul * (1 / (double) (N * N)) * r_i[i];
						
          }
        }
      }
		}
    for (unsigned long long i = 0; i < num_matrix; i++) {
			r_i[i] = r_f[i];
    	if (r_f[i] != 0.0) s_f.push_back(i);
		}
		chk += 1;
		if (s_f == s_i) break;
  }
	std::cout << flip_idx << " " << chk << "\n";
	int len_f = s_f.size();
	for (int i = 0; i < len_f; i++){
    std::vector<double> r_f(num_matrix, 0.0);
		int state_i = s_f[i];
    int mat_i[N][N] = {0,};
    int mat_f[N][N] = {0,};
    idx_to_mat(state_i, mat_i);
    for (int x = 0; x < N; x++) {
      for (int y = 0; y < N; y++) {
        for (int m = 0; m < n_num; m++) {
          std::copy(&mat_i[0][0], &mat_i[0][0] + N * N, &mat_f[0][0]);
          prob_mul = 1.0;
          for (int l = 0; l < N; l++) {
            int idx_n = n_list[m][l];
            switch (rule_num) {
              case 4 :
                L4_rule(mat_f, l, x, y, idx_n);
                break;
              case 6 :
                L6_rule(mat_f, l, x, y, idx_n);
                break;
            }
            prob_mul *= array[idx_n];
         } 
         int state_f = mat_to_idx(mat_f);
     	   r_f[state_f] += prob_mul * (1 / (double) (N * N));
        }
      }
    }
		for (int k = 0; k < num_matrix; k++) {
			if ((r_f[k] != 0) && (state_i != k)) opening << state_i << " " << k << " " << r_f[k] << "\n"; 
		}
	}
  opening.close();
}
