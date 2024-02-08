#include <iostream>
#include <cstdlib>
#include <vector>
#include <fstream>
#include <array>
#include <map>
#include <cmath>
#include <algorithm>
#include <chrono>
#include "Configuration.hpp"

constexpr int N = 6;

bool L6(bool o_d, bool o_r, bool d_r) {  // o_d: o -> d, o_r: o -> r, d_r: d -> r
  return o_r == d_r;  // return true when the recipient reputation aligns with the donor's action
  // if (o_r) return d_r;  // when meets G
  // else return !d_r;  // when G meets B
}

bool L4(bool o_d, bool o_r, bool d_r) {
  return ((!d_r || o_d || o_r) && (d_r || !o_r)); // L4 rule (simplified from NAND gate sequence.)
}

unsigned long long mat_to_idx(int mat[][N]) {
  unsigned long long idx = 0, binary_num = 0;
  idx = binary_num = 0;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      int element = ((int) (mat[N - i - 1][N - j - 1] + 1) / 2);
      idx += element * (int) pow(2, binary_num);
      binary_num += 1;
    }
  }
  return idx;
}

void balanced_idx(std::vector<unsigned long long> &bal_list) {
  const size_t max_idx = (1ull << N) - 1;
  std::vector<std::array<int, N> > id_mat(max_idx);
  for (int i = 0; i < max_idx; i++) {
    int idx = i;
    for (int j = 0; j < N; j++) {
      int id = idx & 1;
      id_mat[i][j] = id;
      idx = idx >> 1;
    }
  }
  int max_num = 0;
  for (int i = 0; i < max_idx; i++) {
    int mat[N][N] = {0,};
    for (int x = 0; x < N; x++) {
      for (int y = 0; y < N; y++) {
        if (id_mat[i][x] == id_mat[i][y]) mat[x][y] = mat[y][x] = 1;
        else mat[x][y] = mat[y][x] = -1;
      }
    }
    unsigned long long bal_idx = mat_to_idx(mat);
    if (i == 0) {
      bal_list.push_back(bal_idx);
      max_num += 1;
    } else {
      int check = 0;
      int different = 0;
      for (int k = 0; k < max_num; k++) {
        check += 1;
        if (bal_list[k] != bal_idx) different += 1;
      }
      if (check == different) {
        bal_list.push_back(bal_idx);
        max_num += 1;
      }
    }
  }
}

using transition_t = std::vector<std::pair<size_t,double>>;
void CalculateTransitionsWithDonor(const Configuration& config, size_t d, double err, transition_t& transitions, int rule_num) {
  // transition from config when the donor is d

  // initialize dests with zero
  // from `config` to the configurations that differs in d-th column
  std::vector<double> dests(1 << N, 0.0);

  for (size_t r = 0; r < N; r++) {
    std::bitset<64> expected(0);  // updated d-th column without error
    for (size_t o = 0; o < N; o++) {  // [TODO] replace with bitwise operation. could be simpler
      bool b;
	  switch(rule_num){
	    case 4:
		  b = L4(config.get(o, d), config.get(o, r), config.get(d, r));
		break;

		case 6:
		  b = L6(config.get(o, d), config.get(o, r), config.get(d, r));
		break;
	  }
      expected.set(o, b);
    }
    for (size_t i = 0; i < dests.size(); i++) {
      std::bitset<64> dest(i);
      size_t num_diff = (expected ^ dest).count();  // count the number of errors
      // dests[i] += std::pow(1.0 - err, N - num_diff) * std::pow(err, num_diff) / (N * (N - 1));  // [TODO] this is the slowest part
      double prob = 1.0 / (N * N);  // probability of choosing the recipient
      for (size_t power = 0; power < num_diff; power++) {
        prob *= err;
      }
      for (size_t power = 0; power < N - num_diff; power++) {
        prob *= (1.0 - err);
      }
      dests[i] += prob;
    }
  }

  Configuration dest_config = config;
  for (size_t i = 0; i < (1 << N); i++) {
    dest_config.set_column(d, std::bitset<64>(i));
    transitions.emplace_back(dest_config.ID(), dests[i]);
  }
}

void CalculateTransitionsFrom(const Configuration& config, double err, transition_t& transitions, int rule_num) {
  // when the donor is d
  for (size_t d = 0; d < N; d++) {
    CalculateTransitionsWithDonor(config, d, err, transitions, rule_num);
  }
}


int main(int argc, char *argv[]) {
  if (argc < 6) {
    std::cerr << "./L_power2 err iter rule_num init_vect_idx, bal_idx flip_idx \n";
    std::cerr << "rule_num : 4(L4_rule), 6(L6_rule) \n";
    std::cerr << "init_vect_idx : 0(histogram), 1(balanced_state), 2)(flipped_configuration)\n";
    return 1;
  }

  const double err = std::strtod(argv[1], nullptr);
  const size_t iter = std::strtoul(argv[2], nullptr, 10);
  const long rule_num = std::strtol(argv[3], nullptr, 10);
  const long init_vect_idx = std::strtol(argv[4], nullptr, 10);
  const long bal_idx = std::strtol(argv[5], nullptr, 10);
  const long flip_idx = std::strtol(argv[6], nullptr, 10);

  std::cerr << "err: " << err << " iter: " << iter << " rule_num: " << rule_num << " init_vect_idx: " << init_vect_idx << " bal_idx: " << bal_idx << " flip_idx: " << flip_idx << std::endl;

  if (rule_num != 4 && rule_num != 6) {
    std::cerr << "rule_num must be 4 or 6" << std::endl;
    return 1;
  }
  if (init_vect_idx < 0 || init_vect_idx > 2) {
    std::cerr << "init_vect_idx must be 0, 1, or 2" << std::endl;
    return 1;
  }

  const size_t NN = 1 << (N*N);  // 2^(N*N)
	const size_t num_of_bal = 1 << (N-1);

  std::vector<unsigned long long> bal_list = {};
  balanced_idx(bal_list);
  sort(bal_list.begin(), bal_list.end());
	/*
	for (int i = 0; i < num_of_bal; i++) {
		std::cout << bal_list[i] << "\n";
	}
	*/
	
  //auto start = std::chrono::system_clock::now();

  // construct transition matrix
  // since it is a sparse matrix, use a vector of maps
  // T[i][j] = probability of transitioning from i to j

  std::vector<transition_t> T(NN);
  for (size_t i = 0; i < NN; i++) {
	/*
    if (i % 100'000 == 0) {
      std::cerr << " i: " << i << std::endl;
    }
    if (i == 100'000) break;
	*/
    Configuration config(N, i);
    // find the destinations from i
    CalculateTransitionsFrom(config, err, T[i], rule_num);
  }
  /*
  auto end = std::chrono::system_clock::now();
  std::cerr << "elapsed time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0 << " s" << std::endl;
  return 0;
  */

  // update state using power iteration
  // state vector
  //std::vector<double> state(NN, 1.0 / NN);
	std::ofstream opening;
	std::vector<double> state(NN, 0.0);
	char result[100];
  switch (init_vect_idx) {
		case 0:{
			sprintf(result, "./N%dL%ld_e%dt%ld.dat", N, rule_num, (int) log10(err), iter);
			opening.open(result);
			for (int i = 0; i < NN; i++) {
				state[i] = 1.0 / (double) NN;
      }
			break;
		}
		
		case 1:{
			sprintf(result, "./N%dL%ld_e%d_bal%ld.dat", N, rule_num, (int) log10(err), bal_idx);
			opening.open(result);
			unsigned long long bal_elem = bal_list[bal_idx];
			state[bal_elem] = 1.0;
			break;
		}
		
		case 2:{
			sprintf(result, "./N%dL%ld_flip%ld.dat", N, rule_num, flip_idx); // err = 0 for init_vect_idx = 2.
			opening.open(result);
			//std::vector<unsigned long long> flip_list_N4 = {34167, 35891, 49151, 51063, 52787};
			std::vector<unsigned long long> flip_list_N6 = {39183054815, 34753869791, 56643875791, 35169039311, 65378742727, 43903906247, 51539607551};
			unsigned long long flip_elem = flip_list_N6[flip_idx];
			state[flip_elem]= 1.0;
			break;
		}
  }

  for (size_t t = 0; t < iter; t++) {
    std::vector<double> new_state(NN, 0.0);
    for (size_t i = 0; i < NN; i++) {
      for (auto &dest : T[i]) {
        new_state[dest.first] += state[i] * dest.second;
      }
    }
    state = new_state;
		if (init_vect_idx == 0) {
			if (t == iter - 1) {
				for (size_t i = 0; i < NN; i++) {
					opening << state[i] << " ";
				}
			}
		}
		else if (init_vect_idx == 1) {
			for (size_t i = 0; i < num_of_bal; i++) {
				unsigned long long bal_elem = bal_list[i];
				opening << state[bal_elem] << " ";
			}
			opening << "\n";
		}
		else if (init_vect_idx == 2) {
			for (size_t i = 0; i < num_of_bal; i++) {
				unsigned long long bal_elem = bal_list[i];
				opening << state[bal_elem] << " ";
			}
			opening << "\n";
		}
  }

  return 0;
}
