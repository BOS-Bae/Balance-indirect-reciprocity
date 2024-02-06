#include <iostream>
#include <gtest/gtest.h>
#include "Configuration.hpp"

TEST(Configuration, Configuration) {

  Configuration config(3, 0);
  EXPECT_EQ(config.ID(), 0);
  EXPECT_EQ(config.to_string(), "000\n000\n000\n");
  config.set(0, 0, true);
  EXPECT_EQ(config.to_string(), "100\n000\n000\n");
  config.set(1, 0, true);
  EXPECT_EQ(config.to_string(), "100\n100\n000\n");
  EXPECT_EQ(config.ID(), 0b000'001'001);
  EXPECT_EQ(config.get(0, 0), true);
  EXPECT_EQ(config.get(1, 0), true);
  EXPECT_EQ(config.get(2, 0), false);

  EXPECT_EQ(config.get_column(0), std::bitset<64>("011"));
  EXPECT_EQ(config.get_column(1), std::bitset<64>("000"));
  config.set_column(2, 0b110);
  EXPECT_EQ(config.to_string(), "100\n101\n001\n");

  Configuration config2(3, 1);
  EXPECT_EQ(config2.ID(), 1);
  EXPECT_EQ(config2.to_string(), "100\n000\n000\n");
  config2.set(0, 0, false);
  EXPECT_EQ(config2.ID(), 0);
}
