#include <random>
#include <vector>
#include <cmath>
#include <algorithm>
#include <iostream>

const double b = 1;
const double c = 0.5;

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

int L8_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) val = mat_f[o][r];
	else {
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}	
  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L7_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) {
		if (mat_f[o][d] == 1) val = 1;
		else val = mat_f[o][r];
	}
	else {
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}
  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L6_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  int val_update = (idx_err == 0 ? mat_f[o][r] * act : -mat_f[o][r] * act);
	return val_update;
}

int L5_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) {
		if (mat_f[o][d] == 1) val = mat_f[o][r];
		else val = 1;
	}
	else val = -mat_f[o][r];

	int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L4_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
  // mat_f should be empty matrix whose size is N by N.
  int val = mat_f[o][d];
  if (act == 1) {
    if (mat_f[o][d] == -1) val = mat_f[o][r];
  } 
	else val = -mat_f[o][r];

  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L3_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) val = 1;
	else val = -mat_f[o][r];

  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L2_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) {
		if (mat_f[o][d] == 1) val = mat_f[o][r];
		else val = 1;
	}
	else {
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}
	
  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

int L1_rule(vector<vector<int>> &mat_f, int o, int d, int r, int act, int idx_err) {
	int val = mat_f[o][d];
	if (act == 1) val = 1;
	else {
		if (mat_f[o][d] == 1) val = -mat_f[o][r];
		else val = -1;
	}

  int val_update = idx_err == 0 ? val : -val;
	return val_update;
}

//bool check_absorbing(int rule_num, vector<vector<int>> &mat_i, vector<int> &rule_type, int N){
//	bool bool_val = false;
//	int check = 0;
//	int count = 0;
//	vector<vector<int>> mat_f(N, vector<int>(N,0));
//  std::copy(mat_i.begin(), mat_i.end(), mat_f.begin());
//	for (int o=0; o<N; o++){
//		for (int d=0; d<N; d++){
//			for (int r=0; r<N; r++){
//				int tmp = mat_f[o][d];
//				int act = mat_f[d][r]; // for L3 ~ L8.
//				if (rule_type[d] == 1 || rule_type[d] == 2) { // for L1 and L2.
//					if (mat_f[d][d] == 1) act = mat_f[d][r];	
//					else act = 1;
//				}
//        switch (rule_type[o]) {
//          case 1 :
//            mat_f[o][d] = L1_rule(mat_f, o, d, r, act, 0);
//            break;
//          case 2 :
//            mat_f[o][d] = L2_rule(mat_f, o, d, r, act, 0);
//            break;
//          case 3 :
//            mat_f[o][d] = L3_rule(mat_f, o, d, r, act, 0);
//            break;
//          case 4 :
//            mat_f[o][d] = L4_rule(mat_f, o, d, r, act, 0);
//            break;
//          case 5 :
//            mat_f[o][d] = L5_rule(mat_f, o, d, r, act, 0);
//            break;
//          case 6 :
//            mat_f[o][d] = L6_rule(mat_f, o, d, r, act, 0);
//            break;
//					case 7 :
//						mat_f[o][d] = L7_rule(mat_f, o, d, r, act, 0);
//						break;
//					case 8 :
//						mat_f[o][d] = L8_rule(mat_f, o, d, r, act, 0);
//						break;
//        }
//				count += 1;
//				if (mat_f[o][d] == mat_i[o][d]) check += 1;
//				mat_f[o][d] = tmp;
//			}
//		}
//	}
//	if (count == check) bool_val = true;
//	return bool_val;
//}

void ABM_complete(vector<vector<int>> &mat_i, vector<int> &rule_type, vector<double> &payoff, int N, int t_measure, int MCS, double assess_err, double action_err) {
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> dist(0, N-1);
	uniform_real_distribution<> dist_u(0, 1);
	
	//vector<vector<double>> payoff_matrix = {{b-c, -c}, {b, 0}};
	vector<double> count(N, 0);

	for (int i=0; i<N; i++){
		vector<int> sigma;
		for (int j=0; j<N; j++) {
			int s_ij = dist_u(gen) < 0.5 ? 1 : -1;
			sigma.push_back(s_ij);
		}
		mat_i.push_back(sigma);
	}

	int t = 0;
	int t_m = 0;
	while (true){
		t += 1;	
		int val_check = 0;
		int d = dist(gen);
		int r = dist(gen);
		
		vector<int> update_od = {};
		int act = mat_i[d][r]; // for L3 ~ L8.
 		if (rule_type[d] == 1 || rule_type[d] == 2) { // for L1 and L2.
 			if (mat_i[d][d] == 1) act = mat_i[d][r];	
 			else act = 1;
 		}
		if (dist_u(gen) < action_err) act *= -1;
 
		for (int o=0; o<N; o++) {
			int idx_err = dist_u(gen) < assess_err ? 1 : 0; 
  	  switch (rule_type[o]) {
				case 1 :
  	   	  update_od.push_back(L1_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 2 :
  	   	  update_od.push_back(L2_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 3 :
  	   	  update_od.push_back(L3_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 4 :
  	   	  update_od.push_back(L4_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 5 :
  	   	  update_od.push_back(L5_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 6 :
  	   	  update_od.push_back(L6_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 7 :
  	   	  update_od.push_back(L7_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
  	   	case 8 :
  	   	  update_od.push_back(L8_rule(mat_i, o, d, r, act, idx_err));
  	   	  break;
			}
		}
		for (int o=0; o<N; o++) mat_i[o][d] = update_od[o];
		//print_mat(mat_i, N);
		if (t >= t_measure) {
			t_m += 1;
			if (act == 1) {
				payoff[d] -= c;
				payoff[r] += b;
			}
			count[d] += 0.5;
			count[r] += 0.5;
		}
		if (t == MCS) {
			//print_mat(mat_i, N);
			for (int i=0; i<N; i++) payoff[i] /= count[i];
			break;
		}
	}
}

double cluster_difference(vector<vector<int>> &mat_f, int N) {
	double c_diff = 0;
	int c_1_size = 0;
	for (int i=0; i<N; i++) {
		if (mat_f[0][i] == 1) c_1_size += 1;
	}
	int c_diff_int = (c_1_size - (N - c_1_size));
	c_diff = (double)c_diff_int / (double)N;
	
	return c_diff;
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
	if (argc < 7) {
		cout << "./game_L4 N mutant_rule n_sample MCS t_measure assess_err action_err \n";
		cout << "mutant_rule : 1 ~ 8 (leading eight). \n";
		cout << "N should be set to be larger or equal to 50. \n";
		exit(1);
	}

	int N = atoi(argv[1]);
	int m_rule = atoi(argv[2]); // mutant type
	int n_sample = atoi(argv[3]);
	int MCS = atoi(argv[4]); // total Monte Carlo steps
	int t_measure = atoi(argv[5]); // total Monte Carlo steps
	double assess_err = atof(argv[6]);
	double action_err = atof(argv[7]);
	double frac_m = 0.1;
	int num_m = (int)(N * frac_m);

	int resident_type = 4; // L4

	vector<double> r_arr;
	vector<double> m_arr;
	double r_avg = 0;
	double m_avg = 0;

	for (int n_s=0; n_s < n_sample; n_s++){
		vector<vector<int>> mat_i;
		vector<int> rule_type(N, resident_type);
		for (int i=0; i<num_m; i++) rule_type[i] = m_rule;
		//for (int i=0; i<N; i++) cout << rule_type[i] << " ";
		//cout <<"\n";
		vector<double> payoff(N, 0);
		ABM_complete(mat_i, rule_type, payoff, N, t_measure, MCS, assess_err, action_err);
		//print_mat(mat_i, N);

		double r_payoff = 0; // the payoff of the residents
		double m_payoff = 0; // the payoff of the mutants
		for (int i=0; i<N; i++) {
			if (i < num_m) m_payoff += payoff[i];
			else r_payoff += payoff[i];
		}
		r_payoff /= (double)(N-num_m);
		m_payoff /= (double)(num_m);
		r_arr.push_back(r_payoff);
		m_arr.push_back(m_payoff);
		r_avg += r_payoff;
		m_avg += m_payoff;
	}
	r_avg /= (double)n_sample;
	m_avg /= (double)n_sample;
	
	double std_r = 0; double std_m = 0;
	double std_err_r; double std_err_m = 0;
	for (int n_s=0; n_s < n_sample; n_s++){
		std_r += pow((r_arr[n_s] - r_avg),2);
		std_m += pow((m_arr[n_s] - m_avg),2);
	}
	std_err_r = sqrt(std_r / (double)(n_sample*(n_sample - 1)));
	std_err_m = sqrt(std_m / (double)(n_sample*(n_sample - 1)));
	
	cout << "L" << resident_type << " " << r_avg << " " << std_err_r << " L" << m_rule << " " << m_avg << " " << std_err_m << "\n";
	return 0;
}
