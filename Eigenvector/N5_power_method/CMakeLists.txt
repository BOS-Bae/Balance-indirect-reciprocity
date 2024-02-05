cmake_minimum_required(VERSION 3.7)
project(N5_power_method)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

add_executable(L_power L_power.cpp)
