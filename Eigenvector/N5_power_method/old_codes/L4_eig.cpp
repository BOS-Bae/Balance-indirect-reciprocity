#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <random>

using std::cout;
using std::ofstream;
using std::uniform_int_distribution;
using std::vector;
using std::copy;

constexpr int N = 6;

void idx_to_mat(unsigned long long idx, int mat[][N]);
unsigned long long mat_to_idx(int mat[][N]);
void balanced_idx(vector<unsigned long long>& bal_list);
void L4_rule(int mat_f[][N], int o, int d, int r, int idx_err);
void n_list_gen(int n_num, int n_list[][N]);

int main(int argc, char* argv[]) {
  if(argc<2){
  	printf("./L6_eig err iter \n");
  	exit(1);
  }
  double err = atof(argv[1]);
  constexpr int n_num = 1 << N;
  int iter = atoi(argv[2]);  
  double array[2];
  array[0] = (1.0 - err); array[1] = err;
  
  int n_list[n_num][N];
  double prob_mul;
  n_list_gen(n_num, n_list);
  //for (i=0; i < 16; i++){
  //	for (j=0; j < 4; j++){
  //		cout << n_list[i][j] << " ";
  //	}
  //	cout << "\n";
  //}
  std::random_device rd;
  std::mt19937 gen(rd());
  
  std::uniform_real_distribution<> distri(0.0,1.0);  
  constexpr size_t num_matrix = 1 << (N * N);
  std::vector<double> r_i(num_matrix, 0.0);
  double summ = 0.0;
  for (int i = 0; i < num_matrix; i++){
  	r_i[i] = distri(gen);
  	summ += r_i[i];
  }
  for (int i = 0; i < num_matrix; i++){
  	r_i[i] /= summ;
  }
  int idx_f; // index of mat_f, which is the matrix updated by assessment rule.
  for (int t = 0; t < iter; t++){
  	//for (i=0; i<num_matrix; i++) r_f[i] = 0.0;
  	std::vector<double> r_f(num_matrix, 0.0);
  	for (int i = 0; i < num_matrix; i++){
  	  int mat_i[N][N] = {0,}; int mat_f[N][N];
  	  idx_to_mat(i, mat_i);
  	  for (int x = 0; x < N; x++){
  	  	for (int y = 0; y < N; y++){
  		  // n_list[16][4]
  		  for (int m = 0; m < n_num; m++){
  		  	copy(&mat_i[0][0], &mat_i[0][0]+N*N, &mat_f[0][0]);
  		  	prob_mul = 1.0;
  		  	for (int l = 0; l < N; l++){
  		  		int idx_n = n_list[m][l];
  		  		L4_rule(mat_f, l, x, y, idx_n);
  		  		prob_mul *= array[idx_n]; 
  		  	}
  		  	idx_f = mat_to_idx(mat_f);
  		  	//cout << idx_f << "\n";
  		  	r_f[idx_f] += prob_mul*(1/(double)(N*N))*r_i[i];
  		  }
  	  	}
  	  }
  	}
  	for (int i = 0; i < num_matrix; i++){
  		r_i[i] = r_f[i];
  	}
  }
  char result[100];
  sprintf(result, "./N%dL4_e%st%d.dat", N, argv[1],iter);
  ofstream opening;
  opening.open(result);
  for (int i = 0; i < num_matrix; i++){
  	opening << r_i[i] << " ";
  }
  return 0;
}

void balanced_idx(vector<unsigned long long>& bal_list){
	int max_idx = (int)pow(2,N)-1;
	int id_mat[max_idx][N] = {0,};
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
			int check = 0; int different = 0;
			for (int k = 0; k < max_num; k++) {
				check += 1;
				if (bal_list[k] != bal_idx)	different += 1;
			}
			if (check == different) {
				bal_list.push_back(bal_idx);
				max_num += 1;
			}
		}
	}
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
