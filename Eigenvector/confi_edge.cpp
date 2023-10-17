#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>
#include <vector>
#include <random>

using std::cout;
using std::ofstream;
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
	//int num_e_matrix = pow(2,N*(N-1));
	int num_e_matrix = pow(2,N*(N-1)/2);
    
//	vector<vector<vector<int>>> matrices;
//	vector<vector<int>> matrix;
	vector<int> list;
	
    vector<vector<vector<int>>> matrices;
    vector<vector<vector<int>>> dynamic_mats;
	vector<vector<int>> e_matrix;
	
    for (idx=0; idx < num_e_matrix; idx++){
		e_matrix = {};
		tmp_idx = idx;
		for (i=0; i<N; i++){
			list = {};
			for (j=0; j<N; j++){
                if (j>i){
				bit = tmp_idx & 1;
				tmp_unit = bit == 0 ? 1 : -1;
				list.push_back(tmp_unit);
				tmp_idx >>= 1;
                }
                else list.push_back(0);
			}
			e_matrix.push_back(list);
		}
        for (i=0; i<N; i++){
            for (j=i; j<N; j++){
                e_matrix[j][i] = e_matrix[i][j];
            }
        }
		matrices.push_back(e_matrix);
        dynamic_mats.push_back(e_matrix);
	}
    /* 
    for (idx=0; idx < num_e_matrix; idx++){
		matrix = {};
		tmp_idx = idx;
		for (i=0; i<N; i++){
			list = {};
			for (j=0; j<N; j++){
                if (i!=j){
				bit = tmp_idx & 1;
				tmp_unit = bit == 0 ? 1 : -1;
				list.push_back(tmp_unit);
				tmp_idx >>= 1;
                }
                else list.push_back(0);
			}
			matrix.push_back(list);
		}
		matrices.push_back(matrix);
	}
    */
/*
	int leng, tmp, val = 0;
    int arr[N];
	double summ;
	//Check if the matrix elements are given well.
	for (i=0; i<num_e_matrix; i++){

		for (j=0; j<num_e_matrix; j++){
			if (matrices[i] == matrices[j]){
				cout << i << ", " << j << "\n";
			}
		}
	}
	cout << "no err \n";
	*/
	// for applying power method (instead of exact diagonalization)
	
    /*
    // for matrix in which edge balance is satisfied, also.
    for (idx=0; idx<num_e_matrix; idx++){
        for (j=0; j<N; j++){
            for (k=0; k<N; k++){
                cout << matrices[idx][j][k] << " ";
            }
            cout <<", ";
        }
        cout <<"\n";

	    for (i=0; i<num_e_matrix; i++){
            if (matrices[i] == matrices[idx]  && i!=idx ) cout << i << "\n";
        }
    }
	double r_i[num_e_matrix], r_f[num_e_matrix];
	for (i=0; i<num_e_matrix; i++){
		r_i[i] = distri(gen);
	}
    int edge_bool = 0;

	for (t=0; t<iter; t++){
		cout << t << "\n";
		for (i=0; i<num_e_matrix; i++){
			for (x=0; x<N; x++){
				for (y=0; y<N; y++){
                    if (x!=y){
                        while (true){
			    		    tmp = matrices[i][x][y];
                            if (err != 0){
    			    		    dynamic_mats[i][x][y] *= -1;

    			    		    for (j=0; j<num_e_matrix; j++){
			    			        if (matrices[j] == dynamic_mats[i] && i!=j){
			    			    	    r_f[j] += (1/15)*err*r_i[i];
                                        edge_bool = 1;
			    			        }
    			    		    }
                            }

    			    		for (k=0; k<N; k++){
                                if (k!=x && k!=y){
    			    	    		val = 0;
    			    	    		if (dynamic_mats[i][x][y] == 1){
    			    	    			if (dynamic_mats[i][k][x] == 1){
    			    	    				val = 1;
    			    	    			}
    			    	    			else{
    			    	    				dynamic_mats[i][k][x] = dynamic_mats[i][k][y];
    			    	    			}
    			    	    		}
    			    	    		else{
    			    	    			val = -dynamic_mats[i][k][y];
    			    	    		}
    			    	    		dynamic_mats[i][k][x] = val; // L4_rule
    
    			    	    		for (j=0; j<num_e_matrix; j++){
    			    	    			if (matrices[j] == dynamic_mats[i]){
    			    	    				r_f[j] += (1-err)*(1/(double)(N*(N-1)*(N-2)))*r_i[i];
                                            edge_bool = 1;
    			    	    			}
    			    	    		}
    			    	    	}
                            }  
                            if (edge_bool){
    			    	        for (k=0; k<N; k++) {
                                    dynamic_mats[i][k][x] = matrices[i][k][x];
                                }
                                dynamic_mats[i][x][y] = tmp;
                                break;
                            } 
			    	    }
                    }
			    }
		    }
        }
    }
    
	summ = 0.0;
	for (i=0; i<num_e_matrix; i++) summ += r_f[i]*r_f[i];
	
	for (i=0; i<num_e_matrix; i++){
		r_f[i] /= sqrt(summ);
		r_i[i] = r_f[i];
	}
    */
	char result[100];
	sprintf(result, "./confi_edge_N%d", N);
	ofstream opening;
	opening.open(result);
    for (idx=0; idx<num_e_matrix; idx++){
        for (j=0; j<N; j++){
            for (k=0; k<N; k++){
                opening << matrices[idx][j][k] << " ";
            }
            opening <<", ";
        }
        opening <<"\n";
    }
	return 0;
}
