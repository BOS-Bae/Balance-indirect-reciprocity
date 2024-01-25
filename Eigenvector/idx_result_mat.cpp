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
const int dat_leng = 16;

void idx_to_mat(int idx, int mat[][N]);
int mat_to_idx(int mat[][N]);

int main(int argc, char* argv[]) {
	if(argc<1){
   		printf("./idx_result_mat idx \n");
   		exit(1);
	}
	int flip_list[6];
	flip_list[0] = 34167; flip_list[1] = 35891; flip_list[2] = 49151; flip_list[3] = 51063; flip_list[4] = 52787;
	//flip_list[5] =34679;
	flip_list[5] = 52275;
	
	int idx = atoi(argv[1]);
	int i,j,k;
	char filename[100] = "./first_fig_f.dat";
	char filename2[100] = "./second_fig_f.dat";
	int mat[N][N];
	FILE *fp = fopen(filename, "r");
	FILE *fp2 = fopen(filename2, "r");
	int result_list[dat_leng];

	if (fp != NULL){
		for (i=0; i<dat_leng; i++){
			if (idx==1) fscanf(fp, "%d", &result_list[i]);
			else if (idx==2) fscanf(fp2, "%d", &result_list[i]);
		}
	}
	fclose(fp);
	//for (i=0; i < 16; i++){
	//	for (j=0; j < 4; j++){
	//		cout << n_list[i][j] << " ";
	//	}
	//	cout << "\n";
	//}
	int val;
	for (i=0; i<dat_leng; i++){
		val = result_list[i];
		idx_to_mat(val, mat);
		for (j=0; j<N; j++){
			for (k=0; k<N; k++){
				cout << mat[j][k] << " ";
			}
			cout << "\n";
		}
		cout << "\n";
	}

	for (i=0; i<6; i++){
		val = flip_list[i];
		idx_to_mat(val, mat);
		for (j=0; j<N; j++){
			for (k=0; k<N; k++){
				cout << mat[j][k] << " ";
			}
			cout << "\n";
		}
		cout << "\n";
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