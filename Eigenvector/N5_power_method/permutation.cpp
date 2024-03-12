#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <set>

const int N = 5;
const int num_matrix = 1 << N*(N-1);
using namespace std;

void idx_to_mat(unsigned long long idx, int mat[][N]) {
	int idx_tmp = idx;
  for (int i = 0; i < N; i++) {
		mat[i][i] = 1;
    for (int j = 0; j < N; j++) {
			if (i!=j){
      	int M_ij = idx_tmp & 1; 
      	mat[i][j] = 2 * M_ij - 1;
				idx_tmp = idx_tmp >> 1;
			}
    }
  }
}

unsigned long long mat_to_idx(int mat[][N]) {
  unsigned long long idx = 0, binary_num = 0;
  idx = binary_num = 0;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
			if (i!=j){
      	int element = ((int) (mat[i][j] + 1) / 2);
      	idx += element * (int) pow(2, binary_num);
      	binary_num += 1;
			}
    }
  }
  return idx;
}

void generatePermutations(vector<vector<int>>& permutations, vector<int>& current, vector<bool>& chosen) {
    if (current.size() == chosen.size()) {
        permutations.push_back(current);
        return;
    }
		// ex. N=4 : 0,1,2,3
    for (int i = 0; i < chosen.size(); i++) {
        if (chosen[i]) continue;
        chosen[i] = true;
        current.push_back(i);
        generatePermutations(permutations, current, chosen);
        current.pop_back();
        chosen[i] = false;
    }
}

vector<vector<int>> applyPermutation(int mat[][N], const vector<int>& permutation) {
	vector<vector<int>> result(N, vector<int>(N, 0));	
    for (int i = 0; i < permutation.size(); i++) {
        for (int j = 0; j < permutation.size(); j++) {
            result[i][j] = mat[permutation[i]][permutation[j]];
        }
    }
    return result;
}

int main() {
		std::ofstream opening;
		char result[100];
		sprintf(result, "./N%d_permute.dat",N);
		opening.open(result);

		vector<vector<int>> permutations;
    vector<int> current;
    vector<bool> chosen(N, false);
    generatePermutations(permutations, current, chosen);
    
		set<set<vector<vector<int>>>> uniqueGroups_set;
    
		for (int i=0; i<num_matrix; i++){
			if (i % 10000 == 0) cout << i << "\n";
			int mat[N][N] = {0,};	
			idx_to_mat(i,mat);
			
			//vector<vector<int>> permutations;
    	//vector<int> current;
    	//vector<bool> chosen(N, false);
    	//generatePermutations(permutations, current, chosen);

    	set<vector<vector<int>>> uniqueGroups;
    	for (const auto& permutation : permutations) {
    	    vector<vector<int>> permutedAdjacency = applyPermutation(mat, permutation);
    	    uniqueGroups.insert(permutedAdjacency);
    	}

    	//cout << "Number of unique groups: " << uniqueGroups.size() << endl;
			int check = 0;
			for (const auto& unique : uniqueGroups_set){
				if (uniqueGroups == unique) check += 1;
			}
			if (check == 0)	uniqueGroups_set.insert(uniqueGroups);
		}
		for (const auto& uniqueGroups : uniqueGroups_set){
			for (const auto& adj : uniqueGroups){
					int mat[N][N] = {0,};
					for (int j=0; j<N; j++){
						for (int k=0; k<N; k++){
							mat[j][k] = adj[j][k];
						}
					}	
					int mat_idx = mat_to_idx(mat);
					opening << mat_idx << " ";
				}
				opening << "\n";
			}
	opening.close();
	return 0;
}

