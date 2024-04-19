#include <random>
#include <vector>
#include <iostream>

using namespace std;
using std::cout;
using std::uniform_int_distribution;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937;
using std::vector;

double cluster_diff(vector<vector<int>> Mat, int N){
	int	cluster_size = 0;
	for (int i=0; i<N; i++){
		if (Mat[0][i] == 1) cluster_size += 1;
	}
	int diff = N-2*cluster_size;
	double diff_fraction = (double)diff/(double)N;

	return diff_fraction;
}

bool balance(vector<vector<int>> Mat, int N){
	int	check = 0;
	int bal = 0;

	bool condition_check = false;
	for (int i=0; i<N; i++){
		for (int j=0; j<N; j++){
			for (int k=0; k<N; k++){
				check +=1 ;
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
}

int L4(vector<vector<int>> Mat, int o, int d, int r){
	int val = 0;
	if (Mat[o][d] == 1 && Mat[d][r] == 1 && Mat[o][r] == -1) val = 1;
	else val = Mat[o][r]*Mat[d][r];
	
	return val;
}

int main(int argc, char *argv[]) {
	if (argc < 4){
		cout << "./ABM_L4 N a n_sample t_interval \n";
		cout << "init_setting = 0: - -> +, = 1 : + -> - \n";
		exit(1);
	}

	int N = atoi(argv[1]);
	int a = atoi(argv[2]);
	int n_sample = atoi(argv[3]);
	int t_delta = atoi(argv[4]);
	
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> dist(0, N-1);
	//uniform_real_distribution<> dist_f(0, 1);
	vector<double> absorption(4, 0.0);

	for (int init_setting=0; init_setting<4; init_setting++){
		vector<double> absorption_i(4, 0.0);
		for (int s=0; s<n_sample; s++){
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
			//if (s==0 && init_setting ==0) print_mat(Mat, N);
			double original_diff = cluster_diff(Mat, N);
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
			
			int t = 0;
			while (true){
				t += 1;	
				int val_check = 0;
				int d = dist(gen);
				int r = dist(gen);
				vector<int> update_od = {};
				for (int o=0; o<N; o++) update_od.push_back(L4(Mat, o, d, r));
				for (int o=0; o<N; o++) Mat[o][d] = update_od[o];
				if (t % t_delta == 0){
					if (balance(Mat, N)) {
						if (cluster_diff(Mat, N) == original_diff) absorption[1] += factor;
						else if (fabs(cluster_diff(Mat, N)) == 1.0) absorption[0] += factor;
						else if (fabs(cluster_diff(Mat,N)) > fabs(original_diff)) absorption[3] += factor;
						else absorption_i[2] += factor;
						val_check = 1;
					}
				}
				if (val_check == 1) break;
			}
		}
		for (int j=0; j<4; j++) absorption[j] += absorption_i[j];
	}
	for (int j=0; j<4; j++) absorption[j] /= (double)n_sample;
	cout << a << ":" << N-a << " ; " << absorption[0] << " " << absorption[1] << " " << absorption[2] << " " << absorption[3] << "\n";
	return 0;
}
