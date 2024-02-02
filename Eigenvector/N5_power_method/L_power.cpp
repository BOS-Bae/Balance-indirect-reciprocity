#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <algorithm>

using std::ofstream;
using std::vector;
using std::copy;
using std::sort;

constexpr int N = 6;

// The reason for using 'usigned long long' : 2^(N*N) exceeds the maximum of 'int', when N=6.
void idx_to_mat(unsigned long long idx, int mat[][N]);
unsigned long long mat_to_idx(int mat[][N]);
void balanced_idx(vector<unsigned long long>& bal_list);
void L4_rule(int mat_f[][N], int o, int d, int r, int idx_err);
void L6_rule(int mat_f[][N], int o, int d, int r, int idx_err);
void n_list_gen(int n_num, int n_list[][N]);
void power_method(double err, int iter, int rule_num, int init_vect_idx, int bal_idx, int flip_idx);

/*
	init_vect_idx = 0 : r_i has elments with uniform values (=1/num_matrix)
	init_vect_idx = 1 : r_i has an element for a balanced index only
	init_vect_idx = 2 : r_i has an element for a balanced index only
	
	init_vect_idx = 0 : 2^(N*N) elements in dat file (whole possible states)
	init_vect_idx = 1 : 2^(N-1) elements in dat file (only balanced states)
	init_vect_idx = 2 : 2^(N-1) elements in dat file (only balanced states)
*/
int main(int argc, char* argv[]) {
  int num_of_bal = (int)pow(2, N - 1);  
  if((argc<6) || (atoi(argv[3]) != 4 && atoi(argv[3]) != 6) 
		|| (atoi(argv[4]) > 2)) {
  	printf("./L_power err iter rule_num init_vect_idx, bal_idx flip_idx \n");
  	printf("rule_num : 4(L4_rule), 6(L6_rule) \n");
  	printf("init_vect_idx : 0(histogram), 1(balanced_state), 2)(flipped_configuration)\n");
  	exit(1);
  }
  double err = atof(argv[1]);
  constexpr int n_num = 1 << N; // number for the possible configurations of err for N observers

  int iter = atoi(argv[2]);
  int rule_num = atoi(argv[3]);
  int init_vect_idx = atoi(argv[4]);
  int bal_idx = atoi(argv[5]);
  int flip_idx = atoi(argv[6]);

	power_method(err, iter, rule_num, init_vect_idx, bal_idx, flip_idx);	
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

void power_method(double err, int iter, int rule_num, int init_vect_idx, int bal_idx, int flip_idx){
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
  array[0] = (1.0 - err); array[1] = err;
  
  int num_of_bal = (int)pow(2, N - 1);
  std::vector<unsigned long long> bal_list = {};
  balanced_idx(bal_list);
  sort(bal_list.begin(), bal_list.end());

  int n_list[n_num][N];
  double prob_mul;
  n_list_gen(n_num, n_list);
  
  constexpr size_t num_matrix = 1 << (N * N);
  std::vector<double> r_i(num_matrix, 0);
	char result[100];
	ofstream opening;
	switch (init_vect_idx) {
		case 0:
		{
 			 sprintf(result, "./N%dL%d_e%dt%d.dat", N,rule_num,(int)log10(err),iter);
 			 opening.open(result);
			for (unsigned long long i = 0; i < num_matrix; i++) {
				r_i[i] = 1/(double)num_matrix;	
			}
			
			break;
		}
		case 1:
		{
 			 sprintf(result, "./N%dL%d_e%f_bal%d.dat", N,rule_num,err,bal_idx);
 			 opening.open(result);
			int bal_elem = bal_list[bal_idx];
			r_i[bal_elem] = 1;
			break;
		}
		case 2:
		{
 			 sprintf(result, "./N%dL%d_e%f_flip%d.dat", N,rule_num,err,flip_idx);
 			 opening.open(result);
			vector<unsigned long long> flip_list_N6 = {39183054815, 34753869791, 56643875791, 35169039311, 65378742727, 43903906247, 51539607551};
			unsigned long long flip_elem = flip_list_N6[flip_idx];
			r_i[flip_elem] = 1;
			break;
		}
	}

  for (int t = 0; t < iter; t++){
  	std::vector<double> r_f(num_matrix, 0.0);
  	for (unsigned long long i = 0; i < num_matrix; i++){
  	  int mat_i[N][N] = {0,}; int mat_f[N][N];
  	  idx_to_mat(i, mat_i);
  	  for (int x = 0; x < N; x++){
  	  	for (int y = 0; y < N; y++){
  		  for (int m = 0; m < n_num; m++){
  		  	copy(&mat_i[0][0], &mat_i[0][0]+N*N, &mat_f[0][0]);
  		  	prob_mul = 1.0;
  		  	for (int l = 0; l < N; l++){
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
  		  	r_f[idx_f] += prob_mul*(1/(double)(N*N))*r_i[i];
  		  }
  	  	}
  	  }
  	}
  	for (unsigned long long i = 0; i < num_matrix; i++){
  		r_i[i] = r_f[i];
  	}
  	switch (init_vect_idx){
  	  case 0:
			{
				if (t == iter-1){
  	    	for (unsigned long long i = 0; i < num_matrix; i++) {
  	  			opening << r_i[i] << " ";
  	    	}
				}
  	  	break;
			}
			case 1:
			{
				for (int i = 0; i < num_of_bal; i++) {
					unsigned long long bal_elem = bal_list[i];
					opening << r_i[bal_elem] << " ";
				}
				opening << "\n";
				break;
			}
			case 2:
			{
				for (int i = 0; i < num_of_bal; i++) {
					unsigned long long bal_elem = bal_list[i];
					opening << r_i[bal_elem] << " ";
				}
				opening << "\n";
				break;
			}
  	}
	}
	opening.close();
}
