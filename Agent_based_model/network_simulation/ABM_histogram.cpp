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

void exchange_vectors(vector<vector<int>> &subsets, vector<vector<int>> &exchanged) {
	exchanged.push_back(subsets[1]);
	exchanged.push_back(subsets[0]);
}

void print_subsets(vector<vector<int>> &subsets) {
	for (int i=0; i<subsets.size(); i++){
		for (int j=0; j<subsets[i].size(); j++) cout << subsets[i][j] << " ";
		cout << "\n";
	}
	cout << "\n";
}

void print_mat(vector<vector<int>> &mat, int N) {
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) cout << mat[i][j] << " ";
		cout << "\n";
	}
	cout << "\n";
}

int subset_to_idx(vector<vector<int>> &subsets, int N) {
	int idx = 0;
	for (int i=0; i<N; i++) {
		int cluster_idx = 0;
		if (find(subsets[0].begin(), subsets[0].end(), i) == subsets[0].end()) cluster_idx = 1;
		idx += (int)(pow(2, i) * cluster_idx);
	}

	return idx;
}

void idx_to_subset(int idx, vector<vector<int>> &subsets, int N) {
	int idx_tmp = idx;
	vector<int> g1 = {};	vector<int> g2 = {};
	for (int i = 0; i < N; i++) {
		int g_idx = idx_tmp & 1;
		if (g_idx == 0) g1.push_back(i);
		else g2.push_back(i);
		idx_tmp = idx_tmp >> 1;
	}
	subsets.push_back(g1);
	subsets.push_back(g2);
}

void init_matrix(vector<vector<int>> &mat, int val, int N) {
	for (int i=0; i<N; i++) {
		vector<int> list;
		for (int j=0; j<N; j++) list.push_back(val);
		mat.push_back(list);
	}
}

void subset_to_mat(vector<vector<int>> &subsets_i, vector<vector<int>> &mat, int N) {
	init_matrix(mat, -1, N);
	
	for (int i=0; i<subsets_i.size(); i++) {
		for (int j=0; j<subsets_i[i].size(); j++) {
			int v = subsets_i[i][j];
			mat[v][v] = 1;
			for (int k=0; k<subsets_i[i].size(); k++) {
				int nei = subsets_i[i][k];
				mat[v][nei] = mat[nei][v] = 1;
			}
		}
	}
}

void mat_to_subset(vector<vector<int>> &mat, vector<vector<int>> &subsets, int N) {
	vector<int> cluster;
	cluster.push_back(0);
	for (int k=1; k<N; k++) {
		if (mat[0][k] == 1) cluster.push_back(k);
	}
	subsets.push_back(cluster);
	int g_num = 1;
	for (int i=1; i<N; i++) {
		int check = 0;
		for (int g=0; g<g_num; g++) {
			if (find(subsets[g].begin(), subsets[g].end(), i) == subsets[g].end()) check += 1;
		}
		if (check == g_num) {
			cluster.clear();
			cluster.push_back(i);
			for (int j=i+1; j<N; j++) {
				if (mat[i][j] == 1) cluster.push_back(j);
			}
			subsets.push_back(cluster);
			g_num += 1;
		}
	}
}

int L6_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_act, int idx_assess) {
  // mat_f should be empty matrix whose size is N by N.
  int val = mat_f[o][d];
	int act = idx_act == 0 ? mat_f[d][r] : -mat_f[d][r];
  int val_update = (idx_assess == 0 ? mat_f[o][r] * act : -mat_f[o][r] * act);
	return val_update;
}

int L4_rule(vector<vector<int>> &mat_f, int o, int d, int r, int idx_act, int idx_assess) {
  // mat_f should be empty matrix whose size is N by N.
  int val = mat_f[o][d];
	int act = idx_act == 0 ? mat_f[d][r] : -mat_f[d][r];
  if (act == 1) {
    if (mat_f[o][d] == -1) val = mat_f[o][r];
  } 
	else val = -mat_f[o][r];

  int val_update = idx_assess == 0 ? val : -val;
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
            mat_f[o][d] = L4_rule(mat_f, o, d, r, 0, 0);
            break;
          case 6 :
            mat_f[o][d] = L6_rule(mat_f, o, d, r, 0, 0);
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

void ABM_complete(int rule_num, vector<vector<int>> &mat_i, vector<double> &f_s, int N, int MCS, double assess_err, double action_err){
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> dist(0, N-1);
	uniform_real_distribution<> dist_u(0, 1);
	int n_bal = (int)pow(2, N);

	for (int i=0; i<N; i++){
		vector<int> sigma;
		for (int j=0; j<N; j++) {
			int s_ij = dist_u(gen) < 0.5 ? 1 : -1;
			sigma.push_back(s_ij);
		}
		mat_i.push_back(sigma);
	}

	int t = 0;
	int count = 0;
	int check_bool = 0;
	
	int segregation_count = 0;

	while (true){
		t += 1;	
		int val_check = 0;
		int d = dist(gen);
		int r = dist(gen);
		int idx_act = (check_bool == 1 && dist_u(gen) < action_err) ? 1 : 0;
		
		vector<int> update_od = {};
		for (int o=0; o<N; o++) {
				//int idx_err = 0;
				int idx_assess = (check_bool == 1 && dist_u(gen) < assess_err) ? 1 : 0;
				//if (check_bool == 1 && dist_u(gen) < assess_err) idx_err = 1;
        switch (rule_num) {
          case 4 :
            update_od.push_back(L4_rule(mat_i, o, d, r, idx_act, idx_assess));
            break;
          case 6 :
            update_od.push_back(L6_rule(mat_i, o, d, r, idx_act, idx_assess));
            break;
				}
		}
		for (int o=0; o<N; o++) mat_i[o][d] = update_od[o];
		//print_mat(mat_i);
		check_bool = 0;

		if (check_absorbing(rule_num, mat_i, N))	{
			vector<vector<int>> subsets;
			mat_to_subset(mat_i, subsets, N);
		  int idx_bal =	subset_to_idx(subsets, N);
			f_s[idx_bal] += 1;
			if (idx_bal != 0) {
				cout << "count : " << count << "\n";
				segregation_count += 1;
			}
			count += 1;
			check_bool = 1;
		}

		if (t == MCS) {
			cout << "seg_count : " << segregation_count << "\n";
			cout << "seg_frag : " << (double)segregation_count / (double)count << "\n";
			for (int i=0; i<n_bal; i++) f_s[i] /= (double)count;
			break;
		}
	}
}

int main(int argc, char *argv[]) {
	if (argc < 6) {
		cout << "./frag_prob N rule_num n_sample MCS assess_error action_error \n";
		exit(1);
	}
	int N = atoi(argv[1]);
	int rule_num = atoi(argv[2]);
	int n_sample = atoi(argv[3]);
	int MCS = atoi(argv[4]);
	double assess_error = atof(argv[5]);
	double action_error = atof(argv[6]);

	vector<vector<int>> mat_i;
	
	int n_bal_tot = (int)pow(2, N);
	int n_bal = (int)pow(2, N-1);
	vector<double> f_s(n_bal_tot, 0);
	vector<double> f_result(n_bal, 0);
	
 	//vector<vector<int>> mat_tes(4, vector<int>(4, 1));
 	//vector<vector<int>> subset_tes;
	//mat_to_subset(mat_tes, subset_tes, 4);
	//int idx_tes = subset_to_idx(subset_tes, 4);
	//cout << idx_tes << "\n";

	ABM_complete(rule_num, mat_i, f_s, N, MCS, assess_error, action_error);

	for (int i=0; i<n_bal_tot; i++) {
		vector<vector<int>> subsets;
		idx_to_subset(i, subsets, N);
		vector<vector<int>>	exchanged;
		exchange_vectors(subsets, exchanged);

		int alter_idx = subset_to_idx(exchanged, N);
		//if (alter_idx >= n_bal && i >= n_bal) cout << "ng\n";
		if (i < n_bal) f_result[i] += f_s[i];
		else f_result[alter_idx] += f_s[i];
	}
	double summ = 0;
	//for (int i=0; i<n_bal_tot; i++) {
	//	cout << f_s[i] << " ";
	//	summ += f_s[i];
	//}
	//cout << summ << "\n";
	for (int i=0; i<n_bal; i++) {
		cout << f_result[i] << " ";
		summ += f_result[i];
	}
	cout <<"\n";
	cout << summ << "\n";

	return 0;
}
