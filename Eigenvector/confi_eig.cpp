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

const int N = 5;

void idx_to_mat(int idx, int mat[][N]){
	int i,j,slice_row,slice_col,M_ij,s_ij;
	for (i=0; i<N; i++){
		slice_row = N*(N-1-i);
		for (j=0; j<N; j++){
			slice_col = N-j-1;
			M_ij = idx >> slice_row >> slice_col & 1;
			mat[i][j] = 2*M_ij-1;
		}
	}
}

void n_list_gen(int n_num, int n_list[][N]){
	int i,j,val,idx;
	for (i=0; i<n_num; i++){
		// The number of possible configurations of assessment eror is n_num.
		val = i;
		for (j=0; j<N; j++){
			n_list[i][j] = val & 1;
			val = val >> 1;
		}
	}
}

void L4_rule(int mat_f[][N], int o, int d, int r, int idx_err){
	// mat_f should be empty matrix whose size is N by N.
	int i,j,val,result;
	val = mat_f[o][d];
	if (mat_f[d][r] == 1){
		if (mat_f[o][d] == -1) val = mat_f[o][r];
	}
	else val = -mat_f[o][r];

	mat_f[o][d] = idx_err == 0 ? val : -val;
}

void L6_rule(int mat_f[][N], int o, int d, int r, int idx_err){
	// mat_f should be empty matrix whose size is N by N.
	int i,j;
	mat_f[o][d] = (idx_err == 0 ? mat_f[o][r]*mat_f[d][r] : -mat_f[o][r]*mat_f[d][r]);
}

int mat_to_idx(int mat[][N]){
	int i,j,idx,element,binary_num;
	idx = binary_num = 0;
	for (i=0; i<N; i++){
		for (j=0; j<N; j++){
			element = ((int)(mat[N-i-1][N-j-1]+1)/2);
			idx += element*(int)pow(2,binary_num);
			binary_num += 1;
		}
	}
	return idx;
}

void idx_to_mat(int idx, int mat[][N]);
int mat_to_idx(int mat[][N]);
void L4_rule(int mat[][N], int mat_f[][N], int o, int d, int r, int idx_err);
void n_list_gen(int n_num, int n_list[][N]);

int main() {
/*
	int i,x,y,z,val,check;
	int num_matrix = pow(2,N*N);
	int mat[N][N];
	
	for (i=0; i<num_matrix; i++){
		val = check = 0;
		idx_to_mat(i, mat);
		for (x=0; x<N; x++){
			for (y=0; y<N; y++){
				for (z=0; z<N; z++){
					val += 1;
					if (mat[x][y]*mat[x][z]*mat[y][z] == 1) check += 1;
				}
			}
		}
		if (val==check) {
			cout << i << " ";
			/*
			cout << i << " :\n";
			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
					cout << mat[x][y] << ", ";
				}
				cout <<"\n";
			}
			*/
	//	}
	//}

	vector<vector<int>> mat_flip_05,mat_flip_14_p,mat_flip_14_n,mat_flip_23_n,mat_flip_23_p;
	mat_flip_05 = {{1,-1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1}}; // flip σ_12
	mat_flip_14_p = {{1,-1,-1,-1,-1},{-1,1,-1,1,1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1}}; // flip σ_23
	mat_flip_14_n = {{1,1,-1,-1,-1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1},{-1,1,1,1,1}}; // flip σ_12
	mat_flip_23_p = {{1,-1,-1,-1,-1},{1,1,-1,-1,-1},{-1,-1,1,1,1},{-1,-1,1,1,1},{-1,-1,1,1,1}}; // flip σ_12
	mat_flip_23_n = {{1,1,-1,-1,-1},{1,1,1,-1,-1},{-1,-1,1,1,1},{-1,-1,1,1,1},{-1,-1,1,1,1}}; // flip σ_23

	int num_matrix = pow(2,N*N);
	int mat[N][N];
	vector<int> input_list;
	int i,x,y,val;

	for (i=0; i< num_matrix; i++){
		vector<vector<int>> mat_confi;
		
		idx_to_mat(i, mat);

		for (x=0; x<N; x++){
			input_list = {};
			for (y=0; y<N; y++){
				input_list.push_back(mat[x][y]);
			}
			mat_confi.push_back(input_list);
		}
		if (mat_confi == mat_flip_05) cout << "0:5 flip :" << i << "\n";
		if (mat_confi == mat_flip_14_p) cout << "1:4 flip p -> n :" << i << "\n";
		if (mat_confi == mat_flip_14_n) cout << "1:4 flip n -> p :" << i << "\n";
		if (mat_confi == mat_flip_23_p) cout << "2:3 flip p -> n :" << i << "\n";
		if (mat_confi == mat_flip_23_n) cout << "2:3 flip n -> p :" << i << "\n";
	}
	return 0;
}
