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

const int N = 4;
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
void L6_rule(int mat[][N], int mat_f[][N], int o, int d, int r, int idx_err);

int main(int argc, char* argv[]) {
	if(argc<2){
   		printf("./L6_eig err iter \n");
   		exit(1);
	}
	double err = atof(argv[1]);
	int n_num = pow(2,N);

	int iter = atoi(argv[2]);
	
	int bal_list[8];
	bal_list[0] = 0; bal_list[1] = 4382; bal_list[2] = 8914;
	bal_list[3] = 13260; bal_list[4] = 19268; bal_list[5] = 23130;
	bal_list[6] = 27030; bal_list[7] = 30856;

	double array[2];
	array[0] = (1.0 - err); array[1] = err;
	
	int n_list[n_num][N];
	int i,j,k,t,x,y,n,m,l,p, idx, tmp_idx, bit, tmp_unit, val;
	int idx_n;
	double prob_mul;
	idx = 0;
	for (n = 0; n < 2; n++){
		for (m = 0; m < 2; m++){
			for (l = 0; l < 2; l++){
				for (p = 0; p < 2; p++){
					n_list[idx][0] = n;
					n_list[idx][1] = m;
					n_list[idx][2] = l;
					n_list[idx][3] = p;
					idx += 1;
				}
			}
		}
	}
	//for (i=0; i < 16; i++){
	//	for (j=0; j < 4; j++){
	//		cout << n_list[i][j] << " ";
	//	}
	//	cout << "\n";
	//}
	std::random_device rd;
	std::mt19937 gen(rd());
	
	// for generating config_matrix
	int num_matrix = pow(2,N*N);
	
	vector<vector<vector<int>>> matrices;
	vector<vector<int>> matrix;
	vector<int> list;
	//void idx_to_mat(int idx, int mat[][N]);
	//int mat_to_idx(int mat[][N]);
	//void L4_rule(int mat[][N], int mat_f[][N], int o, int d, int r, int idx_err);
	
	//vector<vector<int>> mat_flip_04, mat_flip_13_p, mat_flip_22_p, mat_flip_13_n, mat_flip_22_n;
	/*

	mat_flip_04 = {{1,-1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}}; // flip σ_12
	mat_flip_13_p = {{1,-1,-1,-1},{-1,1,-1,1},{-1,1,1,1},{-1,1,1,1}}; // flip σ_23
	mat_flip_13_n = {{1,1,-1,-1},{-1,1,1,1},{-1,1,1,1},{-1,1,1,1}}; // flip σ_12
	mat_flip_22_p = {{1,-1,-1,-1},{1,1,-1,-1},{-1,-1,1,1},{-1,-1,1,1}}; // flip σ_12
	mat_flip_22_n = {{1,1,-1,-1},{1,1,1,-1},{-1,-1,1,1},{-1,-1,1,1}}; // flip σ_23

	for (idx=0; idx <num_matrix; idx++){
		if (matrices[idx] == mat_flip_04) cout << "0:4 flip :" << idx << "\n";
		if (matrices[idx] == mat_flip_13_p) cout << "1:3 flip p -> n :" << idx << "\n";
		if (matrices[idx] == mat_flip_13_n) cout << "1:3 flip n -> p :" << idx << "\n";
		if (matrices[idx] == mat_flip_22_p) cout << "2:2 flip p -> n :" << idx << "\n";
		if (matrices[idx] == mat_flip_22_n) cout << "2:2 flip n -> p :" << idx << "\n";
	}
	*/
	//Check if the matrix elements are given well.
//	for (i=0; i<num_matrix; i++){
//
//		for (j=0; j<num_matrix; j++){
//			if (matrices[i] == matrices[j]){
//				cout << i << ", " << j << "\n";
//			}
//		}
//	}
//	cout << "no err \n";
//	// for applying power method (instead of exact diagonalization)

	std::uniform_real_distribution<> distri(0.0,1.0);

	double r_i[num_matrix] = {0};
	double summ = 0.0;
	for (i=0; i<num_matrix; i++){
		r_i[i] = distri(gen);
		summ += r_i[i];
	}
	for (i=0; i<num_matrix; i++){
		r_i[i] /= summ;
	}
	int idx_f; // index of mat_f, which is the matrix updated by assessment rule.
	for (t=0; t<iter; t++){
		//for (i=0; i<num_matrix; i++) r_f[i] = 0.0;
		double r_f[num_matrix] = {0};
		for (i=0; i<num_matrix; i++){
			//void idx_to_mat(int idx, int mat[][N]);
			//int mat_to_idx(int mat[][N]);
			//void L4_rule(int mat[][N], int mat_f[][N], int o, int d, int r, int idx_err);
			
			int mat_i[N][N] = {0,}; int mat_f[N][N];
			idx_to_mat(i, mat_i);
			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
					// n_list[16][4]
					for (m=0; m<n_num; m++){
						copy(&mat_i[0][0], &mat_i[0][0]+N*N, &mat_f[0][0]);
						prob_mul = 1.0;
						for (l=0; l<N; l++){
							idx_n = n_list[m][l];
							L6_rule(mat_f, l, x, y, idx_n);
							prob_mul *= array[idx_n]; 
						}
						idx_f = mat_to_idx(mat_f);
						//cout << idx_f << "\n";
						r_f[idx_f] += prob_mul*(1/(double)(N*N))*r_i[i];
					}
				}
			}
		}
		for (i=0; i<num_matrix; i++){
			r_i[i] = r_f[i];
		}
	}
	char result[100];
	sprintf(result, "./N%dL6_e%st%d", N, argv[1],iter);
	ofstream opening;
	opening.open(result);
	for (i=0; i<num_matrix; i++){
		opening << r_i[i] << " ";
	}
	return 0;
}
