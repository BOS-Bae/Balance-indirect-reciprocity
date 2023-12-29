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
   		printf("./L4_M err iter bal_idx \n");
   		exit(1);
	}
	int N = 5; // fixed parameter
	double err = atof(argv[1]);
	int n_num = pow(2,N);

	int iter = atoi(argv[2]);
	int bal_idx = atoi(argv[3]);

    char filename[100] = "./N5_confi_list";
    
	int i,j,k,t,x,y,n,m,l,p,z, idx, tmp_idx, bit, tmp_unit, val;
	int bal_list[16];
    FILE *fp = fopen(filename, "r");
    if (fp != NULL){
        for (i=0; i<16; i++){
            fscanf(fp, "%d", &bal_list[i]);
        }
    }
    fclose(fp);
    
    int bal_elem;
	bal_elem = bal_list[bal_idx];
    
	double array[2];
	array[0] = (1.0 - err); array[1] = err;
	
	int n_list[n_num][N];
	int idx_n;
	double prob_mul;
	idx = 0;
	for (n = 0; n < 2; n++){
		for (m = 0; m < 2; m++){
			for (l = 0; l < 2; l++){
				for (p = 0; p < 2; p++){
                    for (z = 0; z < 2; z++){
					    n_list[idx][0] = n;
					    n_list[idx][1] = m;
					    n_list[idx][2] = l;
					    n_list[idx][3] = p;
                        n_list[idx][4] = z;
					    idx += 1;
                    }
				}
			}
		}
	}
	
    std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_real_distribution<> distri(0.0,1.0);
	
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
	
	// for applying power method (instead of exact diagonalization)
	
	double r_i[num_matrix] = {0};
	r_i[bal_elem] = 1;
	double summ = 0.0;

	for (t=0; t<iter; t++){
		double r_f[num_matrix] = {0};
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
			for (i=0; i<num_matrix; i++){
				r_i[i] = r_f[i];
                for (j=0; j<16; j++){
                    if (i == bal_list[j]) cout << r_i[i];
                } 
			}
			cout << "\n";
	}
	return 0;
}
