#include <iostream>
#include <cstdlib>
#include <vector>
#include <array>
#include <map>
#include <chrono>
#include "Configuration.hpp"

constexpr int N = 5;

bool L6(bool o_d, bool o_r, bool d_r) {  // o_d: o -> d, o_r: o -> r, d_r: d -> r
  return o_r == d_r;  // return true when the recipient reputation aligns with the donor's action
  // if (o_r) return d_r;  // when meets G
  // else return !d_r;  // when G meets B
}

std::map<size_t,double> CalculateTransitionsWithDonor(const Configuration& config, size_t d, double err) {
  // transition from config when the donor is d

  // initialize dests with zero
  // from `config` to the configurations that differs in d-th column
  std::vector<double> dests(1 << N, 0.0);

  for (size_t r = 0; r < N; r++) {
    if (d == r) continue;
    std::bitset<64> expected(0);  // updated d-th column without error
    for (size_t o = 0; o < N; o++) {  // [TODO] replace with bitwise operation. could be simpler
      bool b = L6(config.get(o, d), config.get(o, r), config.get(d, r));
      expected.set(o, b);
    }
    for (size_t i = 0; i < dests.size(); i++) {
      std::bitset<64> dest(i);
      size_t num_diff = (expected ^ dest).count();  // count the number of errors
      dests[i] += std::pow(1.0 - err, N - num_diff) * std::pow(err, num_diff) / (N * (N - 1));
    }
  }

  std::map<size_t, double> ans;
  for (size_t i = 0; i < (1 << N); i++) {
    Configuration dest_config = config;
    dest_config.set_column(d, std::bitset<64>(i));
    ans[dest_config.ID()] = dests[i];
  }
  return ans;
}

std::map<size_t,double> CalculateTransitionsFrom(const Configuration& config, double err) {
  std::map<size_t,double> dests;

  // when the donor is d
  for (size_t d = 0; d < N; d++) {
    auto transitions = CalculateTransitionsWithDonor(config, d, err);
    // merge dests and transitions
    for (const auto &[key, value]: transitions) {
      dests[key] += value;
    }
  }
  return dests;
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

  auto start = std::chrono::system_clock::now();

  // construct transition matrix
  // since it is a sparse matrix, use a vector of maps
  // T[i][j] = probability of transitioning from i to j
  const size_t NN = 1 << (N*N);  // 2^(N*N)
  std::vector< std::map<size_t,double> > T(NN);
  for (size_t i = 0; i < NN; i++) {
    if (i % 1'000'000 == 0) {
      std::cerr << " i: " << i << std::endl;
    }
    if (i == 1'000'000) break;
    Configuration config(N, i);
    // find the destinations from i
    std::map<size_t,double> dests = CalculateTransitionsFrom(config, err);
    T[i] = dests;
  }

  auto end = std::chrono::system_clock::now();
  std::cerr << "elapsed time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0 << " s" << std::endl;
  return 0;

  // update state using power iteration
  // state vector
  std::vector<double> state(NN, 1.0 / NN);

  for (size_t t=0; t < iter; t++) {
    std::vector<double> new_state(NN, 0.0);
    for (size_t i = 0; i < NN; i++) {
      for (auto &dest : T[i]) {
        new_state[dest.first] += state[i] * dest.second;
      }
    }
    state = new_state;
  }

  return 0;
}