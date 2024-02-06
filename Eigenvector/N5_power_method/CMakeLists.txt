cmake_minimum_required(VERSION 3.7)
project(N5_power_method)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

include(FetchContent)
FetchContent_Declare(
        googletest
        # Specify the commit you depend on and update it regularly.
        URL https://github.com/google/googletest/archive/5376968f6948923e2411081fd9372e71a59d8e77.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(L_power L_power.cpp)
add_executable(L_power2 L_power2.cpp)


add_executable(test_configuration test_configuration.cpp Configuration.hpp)
target_link_libraries(test_configuration gtest_main)
add_test(NAME test_configuration COMMAND test_configuration)