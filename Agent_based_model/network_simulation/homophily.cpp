#include <random>
#include <vector>
#include <cmath>
#include <algorithm>
#include <iostream>

using namespace std;
using std::cout;
using std::find;
using std::uniform_int_distribution;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937;
using std::vector;

void print_mat(vector<vector<int>> &mat, int N) {
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) cout << mat[i][j] << " ";
		cout << "\n";
	}
	cout << "\n";
}

int L8_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_err) {
	int val = mat_f[o][d];
	if (mat_f[d][r] == 1) val = mat_f[o][r];
	else if (mat_f[d][r] == -1)	{
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}	
  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L7_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_err) {
	int val = mat_f[o][d];
	if (mat_f[d][r] == 1) {
		if (mat_f[o][d] == 1) val = 1;
		else val = mat_f[o][r];
	}
	else if (mat_f[d][r] == -1)	{
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}
  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L4_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  int val = mat_f[o][d];
  if (mat_f[d][r] == 1) {
    if (mat_f[o][d] == -1)
      val = mat_f[o][r];
  } else
    val = -mat_f[o][r];

  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L6_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  int val_update = (idx_err == 0 ? mat_f[o][r] * mat_f[d][r] : -mat_f[o][r] * mat_f[d][r]);
	return val_update;
}

bool check_absorbing(int rule_num, vector<vector<int>> &mat_i, int N){
	bool bool_val = false;
	int check = 0;
	int count = 0;
	vector<vector<int>> mat_f(N, vector<int>(N,0));
  std::copy(mat_i.begin(), mat_i.end(), mat_f.begin());
	for (int o=0; o<N; o++){
		for (int d=0; d<N; d++){
			for (int r=0; r<N; r++){
				int tmp = mat_f[o][d];
        switch (rule_num) {
          case 4 :
            mat_f[o][d] = L4_rule(mat_f, o, d, r, 0);
            break;
          case 6 :
            mat_f[o][d] = L6_rule(mat_f, o, d, r, 0);
            break;
					case 7 :
						mat_f[o][d] = L7_rule(mat_f, o, d, r, 0);
						break;
					case 8 :
						mat_f[o][d] = L8_rule(mat_f, o, d, r, 0);
						break;
        }
				count += 1;
				if (mat_f[o][d] == mat_i[o][d]) check += 1;
				mat_f[o][d] = tmp;
			}
		}
	}
	if (count == check) bool_val = true;
	return bool_val;
}

double ABM_complete(int rule_num, vector<vector<int>> &mat_i, vector<int> &property, int N, double p, int mode_h){
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> dist(0, N-1);
	uniform_real_distribution<> dist_u(0, 1);

	double res = 0;
	for (int i=0; i<N; i++){
		vector<int> sigma;
		for (int j=0; j<N; j++) {
			int s_ij = dist_u(gen) < 0.5 ? 1 : -1;
			sigma.push_back(s_ij);
		}
		mat_i.push_back(sigma);
	}

	int t = 0;
	while (true){
		t += 1;	
		int val_check = 0;
		int d = dist(gen);
		int r = dist(gen);
		
		vector<int> update_od = {};
		for (int o=0; o<N; o++) {
        switch (rule_num) {
          case 4 :
            update_od.push_back(L4_rule(mat_i, o, d, r, 0));
						//cout << L4_rule(mat_i, o, d, r, 0) << "\n"; 
            break;
          case 6 :
            update_od.push_back(L6_rule(mat_i, o, d, r, 0));
            break;
					case 7 :
            update_od.push_back(L7_rule(mat_i, o, d, r, 0));
						break;
					case 8 :
            update_od.push_back(L8_rule(mat_i, o, d, r, 0));
						break;
				}
		}
		for (int o=0; o<N; o++) {
			if (mode_h == 0){
				if (update_od[o] == -1 && dist_u(gen) < p && property[o] == property[d]) mat_i[o][d] = -update_od[o];
				else mat_i[o][d] = update_od[o];
			}
			else if (mode_h == 1){
				if (update_od[o] == 1 && dist_u(gen) < p && property[o] != property[d]) mat_i[o][d] = -update_od[o];
				else mat_i[o][d] = update_od[o];
			}
		}
		//print_mat(mat_i);
		
		res = 0;
		if (check_absorbing(rule_num, mat_i, N)) {
				vector<int> cluster_1;
				for (int i=0; i<N; i++) {
					if (mat_i[0][i] == 1) cluster_1.push_back(i); 
				}
				for (int k=0; k<cluster_1.size(); k++) {
					int node_i = cluster_1[k];
					res += (double)property[node_i];
				}
				//print_mat(mat_i);
				//cout << "\n";
				res /= (double)cluster_1.size();
				break;
		}
	}
	return res;
}

void init_property(vector<int> &property, int N) {
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> dist_u(0, 1);
	double prop_bias = 0.5;
	for (int i=0; i<N; i++) {
		int state_i = dist_u(gen) < prop_bias ? 1 : -1;
		property.push_back(state_i);
	}
}

int main(int argc, char *argv[]) {
	if (argc < 4) {
		cout << "./homophily N p_h rule_num n_sample mode_h\n";
		cout << "mode_h : 0(homohilic) / 1(heteropobic) \n";
		exit(1);
	}

	int N = atoi(argv[1]);
	double p = atof(argv[2]);
	int rule_num = atoi(argv[3]);
	int n_sample = atoi(argv[4]);
	int mode_h = atoi(argv[5]);

	vector<double> result_arr;

	double res_avg = 0;
	for (int n_s=0; n_s < n_sample; n_s++){
		vector<int> property;
		init_property(property, N);
		vector<vector<int>> mat_i;

		double res = fabs(ABM_complete(rule_num, mat_i, property, N, p, mode_h));
		result_arr.push_back(res);
		res_avg += res;
		//if (check == subset_list.size()) print_mat(mat_i, N);
	}
	res_avg /= (double)n_sample;
	
	double std = 0;
	double std_err;
	for (int n_s=0; n_s < n_sample; n_s++){
		std += pow((result_arr[n_s] - res_avg),2);
	}
	std_err = sqrt(std / (double)(n_sample*(n_sample - 1)));
	
	cout << p << " " << res_avg << " " << std_err << "\n";
	return 0;
}
