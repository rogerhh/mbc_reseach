cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")

add_executable(parse_inital_data.exe	parse_initial_data.cpp)
add_executable(sameLuxLevel.exe			sameLuxLevel.cpp)
add_executable(comparison.exe           comparison.cpp)
add_executable(findMax.exe              findMax.cpp)
add_executable(modifyData.exe           modifyData.cpp)
add_executable(read_file.exe            
               read_file.cpp
               DataPoint.cpp
               MBCFunctions.cpp)
