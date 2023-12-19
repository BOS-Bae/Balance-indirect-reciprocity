#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <random>

using std::cout;
using std::ofstream;
using std::uniform_int_distribution;
using std::bernoulli_distribution;
using std::vector;

int main(int argc, char* argv[]) {
	if(argc<3){
   		printf("./L6_M err iter bal_idx \n");
   		exit(1);
	}
	int N = 4;
	double err = atof(argv[1]);
	int n_num = pow(2,N);

	int iter = atoi(argv[2]);
	int bal_idx = atoi(argv[3]);

	int bal_list[8];
	bal_list[0] = 0; bal_list[1] = 4382; bal_list[2] = 8914;
	bal_list[3] = 13260; bal_list[4] = 19268; bal_list[5] = 23130;
	bal_list[6] = 27030; bal_list[7] = 30856;
	int bal_elem;
	bal_elem = bal_list[bal_idx];

	double array[2];
	array[0] = (1.0 - err); array[1] = err;
	
	int n_list[n_num][N];
	int i,j,k,t,x,y,n,m,l,p, idx, tmp_idx, bit, tmp_unit;
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
//	for (i=0; i < 16; i++){
//		for (j=0; j < 4; j++){
//			cout << n_list[i][j] << " ";
//		}
//		cout << "\n";
//	}
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_real_distribution<> distri(0.0,1.0);
	//(distri(gen))
	
	// for generating config_matrix
	int num_matrix = pow(2,N*N);
	
	vector<vector<vector<int>>> matrices;
	vector<vector<int>> matrix;
	vector<int> list;
	
	
	for (idx=0; idx < num_matrix; idx++){
		matrix = {};
		tmp_idx = idx;
		for (i=0; i<N; i++){
			list = {};
			for (j=0; j<N; j++){
				bit = tmp_idx & 1;
				tmp_unit = bit == 0 ? 1 : -1;
				list.push_back(tmp_unit);
				tmp_idx >>= 1;
			}
			matrix.push_back(list);
		}
		matrices.push_back(matrix);
	}
	int leng, tmp = 0;
	
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
	
	double r_i[num_matrix] = {0};
	r_i[bal_elem] = 1;
	double summ = 0.0;

	for (t=0; t<iter; t++){
		//for (i=0; i<num_matrix; i++) r_f[i] = 0.0;
		double r_f[num_matrix] ={0};
		for (i=0; i<num_matrix; i++){
			vector<vector<int>> tmp_mat;
			for (x=0; x<N; x++){
				list = {};
				for (y=0; y<N; y++){
					list.push_back(matrices[i][x][y]);
				}
				tmp_mat.push_back(list);
			}

			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
					int list[N];
					for (k=0; k<N; k++){
						list[k] = matrices[i][k][x];
					}
					// n_list[16][4]
					for (m=0; m<n_num; m++){
						prob_mul = 1.0;
						for (l=0; l<N; l++){
							idx_n = n_list[m][l];
							if (idx_n == 0) matrices[i][l][x] = matrices[i][l][y]*matrices[i][x][y];
							else matrices[i][l][x] = -matrices[i][l][y]*matrices[i][x][y];
							
							prob_mul *= array[idx_n]; 
						}

						for (j=0; j<num_matrix; j++){
							if (matrices[j] == matrices[i] && j!=i){
								r_f[j] += prob_mul*(1/(double)(N*N))*r_i[i];
							}
						}
						if (tmp_mat == matrices[i])	r_f[i] += prob_mul*(1/(double)(N*N))*r_i[i];
						for (l=0; l<N; l++) matrices[i][l][x] = list[l];
					}
					}
				}
			}
			for (i=0; i<num_matrix; i++){
				r_i[i] = r_f[i];
				for (j=0; j<8; j++) {
					if (i == bal_list[j]) cout << r_i[i] << " ";
				}
			}
			cout << "\n";
	}
	return 0;
}
