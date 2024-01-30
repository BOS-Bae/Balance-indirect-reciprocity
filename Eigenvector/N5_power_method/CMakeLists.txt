cmake_minimum_required(VERSION 3.7)
project(N5_power_method)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

add_executable(L4_M L4_M.cpp)
add_executable(L4_f L4_f.cpp)
add_executable(L4_eig L4_eig.cpp)

add_executable(L6_M L6_M.cpp)
add_executable(L6_f L6_f.cpp)
add_executable(L6_eig L6_eig.cpp)
