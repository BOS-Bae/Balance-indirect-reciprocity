#ifndef CONFIGURATION_HPP
#define CONFIGURATION_HPP

#include <iostream>
#include <cstdint>
#include <bitset>

class Configuration {
  public:
  Configuration(size_t N, uint64_t id) {
    // N x N binary matrix configuration
    this->N = N;
    this->config = std::bitset<64>(id);
    if (N > 8) {
      std::cerr << "N must be less than or equal to 8" << std::endl;
      exit(1);
    }
  }

  uint64_t ID() const {
    return this->config.to_ullong();
  }
  bool get(size_t i, size_t j) const {
    return this->config[i * N + j];
  }
  void set(size_t i, size_t j, bool value) {
    this->config[i * N + j] = value;
  }
  void flip(size_t i, size_t j) {
    this->config.flip(i * N + j);
  }
  std::string to_string() const {
    std::string str;
    for (size_t i = 0; i < N; i++) {
      for (size_t j = 0; j < N; j++) {
        str += this->config[i * N + j] ? "1" : "0";
      }
      str += "\n";
    }
    return str;
  }

  size_t N;
  std::bitset<64> config;

  std::bitset<64> get_column(size_t j) const {
    std::bitset<64> column;
    for (size_t i = 0; i < N; i++) {
      column[i] = this->config[i * N + j];
    }
    return column;
  }
  void set_column(size_t j, std::bitset<64> column) {
    for (size_t i = 0; i < N; i++) {
      this->config[i * N + j] = column[i];
    }
  }

};

#endif // CONFIGURATION_HPP