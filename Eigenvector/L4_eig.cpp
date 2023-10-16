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
   		printf("./power_eig N err iter \n");
   		exit(1);
	}
	int N = atoi(argv[1]);
	double err = atof(argv[2]);
	int iter = atoi(argv[3]);

	int i,j,k,t,x,y, idx, tmp_idx, bit, tmp_unit;
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
	int leng, tmp, val = 0;
	double summ;
	/*	
	//Check if the matrix elements are given well.
	for (i=0; i<num_matrix; i++){

		for (j=0; j<num_matrix; j++){
			if (matrices[i] == matrices[j]){
				cout << i << ", " << j << "\n";
			}
		}
	}
	cout << "no err \n";
	*/
	// for applying power method (instead of exact diagonalization)
	
	double r_i[num_matrix], r_f[num_matrix];
	for (i=0; i<num_matrix; i++){
		r_i[i] = distri(gen);
	}

	for (t=0; t<iter; t++){
		cout << t << "\n";
		for (i=0; i<num_matrix; i++){
			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
					tmp = matrices[i][x][y];
					matrices[i][x][y] *= -1;
					for (j=0; j<num_matrix; j++){
						if ((matrices[j] == matrices[i]) && (i != j)){
							r_f[j] += (1/15)*err*r_i[i];
						}
					}
					matrices[i][x][y] = tmp;
					for (k=0; k<N; k++){
						tmp = matrices[i][k][x];
						val = 0;
						if (matrices[i][x][y] == 1){
							if (matrices[i][k][x] == 1){
								val = 1;
							}
							else{
								matrices[i][k][x] = matrices[i][k][y];
							}
						}
						else{
							val = -matrices[i][k][y];
						}
						matrices[i][k][x] = val; // L4_rule

						for (j=0; j<num_matrix; j++){
							if (matrices[j] == matrices[i]){
								r_f[j] += (1-err)*(1/(double)(N*(N-1)*(N-2)))*r_i[i];
							}
						}
						matrices[i][k][x] = tmp;
					}
				}
			}
		}
		summ = 0.0;
		for (i=0; i<num_matrix; i++) summ += r_f[i]*r_f[i];
		
		for (i=0; i<num_matrix; i++){
			r_f[i] /= sqrt(summ);
			r_i[i] = r_f[i];
		}
	}
	char result[100];
	sprintf(result, "./N%dL4_e%s", N, argv[2]);
	ofstream opening;
	opening.open(result);
	for (i=0; i<num_matrix; i++){
		opening << r_f[i] << " ";
	}
	opening << "\n" << "\n";
	for (i=0; i<num_matrix; i++){
		if (fabs(r_f[i]) > 0.1){
			opening << "[";
			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
					opening << matrices[i][x][y] << ", ";
				}
				opening <<"\n";
			}
			opening << "]\n";
		}
	}
	return 0;
}
