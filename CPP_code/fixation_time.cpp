#include <iostream>
#include <random>
#include <vector>
#include "Indirect_network.cpp"

using namespace std;

int main(int argc, char* argv[]) 
{
    int i, j, k, m, n;
	int t, d, r, n_neighbor;
	
    int N = atoi(argv[1]);
    double sl = atof(argv[2]); // dividing : set of connection probabiity (0~1). ex) sl = 10
    int norm = atoi(argv[3]);
    int n_E, n_T;

	if(argc<3){
	   printf("./f_time N slice norm \n");
	   exit(1);
	}
	if (norm != 2 && norm != 3 && norm != 4 && norm != 5 && norm != 6){
		cout << "For leading eight norms : select among 2, 3, 4, 5, 6.";
		exit(1);
	}

    int leng;
    vector<double> P_array;
    for (i=0; i<=1; i++) {
        leng += 1;
        P_array.push_back(1.0/sl);
    }
    
    // int num = atoi(argv[2]); // # of samples
    double prob;
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> agent(0, N - 1);
    uniform_real_distribution<> uni(0,1);

	int **network = new int *[N];
	for (i=0; i<N; i++){
		network[i] = new int[N];
	}
	int **Opinion = new int *[N];
	for (j=0; j<N; j++){
		Opinion[j] = new int[N];
	}

    double Fixationtime[leng];
    for (i = 0; i < leng; i++) {//for each connection probability p
    	prob = P_array[i];//p : 1(connected), 1-p : 0(disconnected)

		vector<vector<int>> E_List = {};
		vector<vector<int>> T_List = {};
		vector<int> n_arr;
    	ER_network_gen(network, prob, N, E_List, T_List, n_E, n_T, uni(gen));
		Opinion_Initialize(Opinion, N, uni(gen));
    	
		t = 0;
    	while (true) {
    		d = agent(gen); r = agent(gen);
    		// Let us choose d and r randomly, and seek observers that are connected with them simultaneously
    		n_arr = {};
			NeighborList(network, n_arr, N, d, r, n_neighbor);
			o_update(norm, Opinion, network, n_arr, n_neighbor, N, d, r, t);

    		if (Check_fixation(Opinion, E_List, T_List, N, n_E, n_T)) break;
		}
		Fixationtime[i] = t;	 // Final t value is fixation time, so let fixation time value enter list
    }
		
	for (i=0; i<leng; i++) cout << Fixationtime[i] << " ";
	
	for (j=0; j<N; j++) delete[] network[j];
	delete[] network;
	for (j=0; j<N; j++) delete[] Opinion[j];
	delete[] Opinion;

    return 0;
}