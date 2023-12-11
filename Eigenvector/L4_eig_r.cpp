#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <random>
#include <cstring>

using std::cout;
using std::ofstream;
using std::uniform_int_distribution;
using std::bernoulli_distribution;
using std::vector;

int main(int argc, char* argv[]) {
	if(argc<3){
   		printf("./L4_eig_r err iter t_i \n");
   		exit(1);
	}
	int N = 4;
	double err = atof(argv[1]);
	int n_num = pow(2,N);

	int iter = atoi(argv[2]);
	int t_i = atoi(argv[3]);
	double array[2];
	array[0] = (1.0 - err); array[1] = err;
	char filename[100] = "../N4L4";
	strcat(filename, "_e");
	strcat(filename, argv[1]);
	strcat(filename, "t");
	strcat(filename, argv[3]);

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
//	for (i=0; i < 16; i++){
//		for (j=0; j < 4; j++){
//			cout << n_list[i][j] << " ";
//		}
//		cout << "\n";
//	}
	std::random_device rd;
	std::mt19937 gen(rd());
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
	
	double r_i[num_matrix], r_f[num_matrix];
	double summ = 0.0;
	FILE *fp = fopen(filename, "r");
	if (fp != NULL){
		for (i=0; i<num_matrix; i++){
			fscanf(fp, "%lf", &r_i[i]);
		}
	}
	fclose(fp);
	
	for (t=0; t<iter; t++){
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
							val = matrices[i][l][x];
							if (matrices[i][x][y] == 1){
								if (matrices[i][l][x] == -1){
									val = matrices[i][l][y];
								}
							}
							else{
								val = -matrices[i][l][y];
							}
							idx_n = n_list[m][l];
							
							if (idx_n == 0) matrices[i][l][x] = val;
							else matrices[i][l][x] = -val;
							
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
			summ = 0.0;
			for (i=0; i<num_matrix; i++){
				r_i[i] = r_f[i];
				summ += r_f[i];
			}
			for (i=0; i<num_matrix; i++){
				r_i[i] /= summ;
			}
	}
	int tot_iter = t_i + iter;	
	char result[100];
	sprintf(result, "./N%dL4_e%st%d", N, argv[1], tot_iter);
	ofstream opening;
	opening.open(result);
	for (i=0; i<num_matrix; i++){
		opening << r_f[i] << " ";
	}
	return 0;
}
