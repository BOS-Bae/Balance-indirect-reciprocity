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

void idx_to_mat(int idx, int mat[][N]);
int mat_to_idx(int mat[][N]);
void L4_rule(int mat[][N], int o, int d, int r, int idx_err);
void n_list_gen(int n_num, int n_list[][N]);

int main(int argc, char* argv[]) {
	if(argc<3){
   		printf("./L4_all_conf err iter flip_idx\n");
   		exit(1);
	}
	double err = atof(argv[1]);
	int n_num = pow(2,N);
	int i,j,k,t,x,y,n,m,l,p, idx, tmp_idx, bit, tmp_unit, val;
	int idx_n;

	int iter = atoi(argv[2]);
	int flip_idx = atoi(argv[3]);

	char filename[100] = "./N4_confi_list";

	FILE *fp = fopen(filename, "r");
	int bal_list[8];
	int flip_list[5];
	flip_list[0] = 34167; flip_list[1] = 35891; flip_list[2] = 49151; flip_list[3] = 51063; flip_list[4] = 52787;

	if (fp != NULL){
		for (i=0; i<8; i++){
			fscanf(fp, "%d", &bal_list[i]);
		}
	}
	fclose(fp);

	int flip_elem;
	flip_elem = flip_list[flip_idx];

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

	int num_matrix = pow(2,N*N);
	
	std::uniform_real_distribution<> distri(0.0,1.0);

	double r_i[num_matrix] = {0};
	r_i[flip_elem] = 1;

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
		for (i=0; i<num_matrix; i++){
			int mat_check[N][N] = {0,};
			r_i[i] = r_f[i];
			if (r_i[i] != 0) {
				idx_to_mat(i, mat_check);
				for (x=0; x<N; x++){
					for (y=0; y<N; y++){
						cout << mat_check[i][j] << " ";
					}
					cout << "\n";
				}
				cout << "\n";
			}
		}
		cout <<"\n";
	}
	return 0;
}

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