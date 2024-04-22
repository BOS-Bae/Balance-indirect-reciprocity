#include <random>
#include <vector>
#include <cmath>
#include <iostream>

using namespace std;
using std::cout;
using std::uniform_int_distribution;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937;
using std::vector;

double average_opinion(vector<vector<int>> Mat, int N){
	int sigma = 0;
	double aver_sigma = 0.0;
	for (int i=0; i<N; i++){
		for (int j=0; j<N; j++) sigma += Mat[i][j];
	}
	aver_sigma = (double)(sigma)/(double)(N*N);

	return aver_sigma;
}

int cluster_diff(vector<vector<int>> Mat, int N){
	int	cluster_size = 0;
	for (int i=0; i<N; i++){
		if (Mat[0][i] == 1) cluster_size += 1;
	}
	int diff = N-2*cluster_size;

	return diff;
}

bool balance(vector<vector<int>> Mat, int N){
	int	check = 0;
	int bal = 0;

	bool condition_check = false;
	for (int i=0; i<N; i++){
		for (int j=0; j<N; j++){
			for (int k=0; k<N; k++){
				check +=1;
				if (Mat[i][j]*Mat[i][k]*Mat[j][k] == 1) bal += 1;
			}
		}
	}
	if (bal == check) condition_check = true;

	return condition_check;
}

void print_mat(vector<vector<int>> Mat, int N){
	for (int i=0; i<N; i++){
		for (int j=0; j<N; j++){
			cout << Mat[i][j] << " ";
		}
		cout << "\n";
	}
	cout << "\n";
}

int L6(vector<vector<int>> Mat, int o, int d, int r){
	int val = 0;
	val = Mat[o][r]*Mat[d][r];
	
	return val;
}

int L4(vector<vector<int>> Mat, int o, int d, int r){
	int val = 0;
	if (Mat[o][d] == 1 && Mat[d][r] == 1 && Mat[o][r] == -1) val = 1;
	else val = Mat[o][r]*Mat[d][r];
	
	return val;
}

int main(int argc, char *argv[]) {
	if ((argc < 3) || atoi(argv[1]) % 2 != 0){
		cout << "./ABM_L4 N a init_setting \n";
		cout << "N must be set to be even number in this code. \n";
		cout << "0 : inner error(a) / 1 : inner error(N-a) / 2 : out error(a->N-a) / 3 : out error(N-a->a) \n";
		exit(1);
	}

	int N = atoi(argv[1]);
	int a = atoi(argv[2]);
	int init_setting = atoi(argv[3]);
	
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> dist(0, N-1);
	//uniform_real_distribution<> dist_f(0, 1);
	vector<double> absorb(4, 0.0);
	
	vector<vector<double>> total_absorb;

	vector<vector<int>> Mat = {};
	// initialization :
	for (int i=0; i<N; i++){
		vector<int>	vec = {};
		for (int j=0; j<N; j++){
			if (i < a){
				if (j < a) vec.push_back(1);
				else vec.push_back(-1);
			}
			else{
				if (j < a) vec.push_back(-1);
				else vec.push_back(1);
			}
		}
		Mat.push_back(vec);
	}

	//print_mat(Mat, N);

	int original_diff = cluster_diff(Mat, N);
	double factor = 0.0;
	if (init_setting == 0) {
		Mat[0][1] *= -1;
		factor = (double)(a*(a-1))/(double)(N*(N-1));
	}
	else if (init_setting == 1) {
		Mat[N-1][N-2] *= -1;
		factor = (double)((N-a)*(N-a-1))/(double)(N*(N-1));
	}
	else if (init_setting == 2) {
		Mat[0][N-1] *= -1;
		factor = (double)(a*(N-a))/(double)(N*(N-1));
	}
	else if (init_setting == 3) {
		Mat[N-1][0] *= -1;
		factor = (double)(a*(N-a))/(double)(N*(N-1));
	}
	//print_mat(Mat, N);
	// 1st : paradise / 2nd : a:N-a / 3rd : toward 1:N-1 / 4th : toward N/2:N/2
	vector<double> t_series = {};
	int t = 0;
	while (true){
		int d = dist(gen);
		int r = dist(gen);
		vector<int> update_od = {};
		for (int o=0; o<N; o++) update_od.push_back(L4(Mat, o, d, r));
		//for (int o=0; o<N; o++) update_od.push_back(L6(Mat, o, d, r));
		for (int o=0; o<N; o++) Mat[o][d] = update_od[o];
		t_series.push_back(average_opinion(Mat, N));

		if (balance(Mat, N)) break;	
		t += 1;	
	}
	
	for (int i=0; i<t_series.size(); i++) cout << t_series[i] << "\n";

	return 0;
}
