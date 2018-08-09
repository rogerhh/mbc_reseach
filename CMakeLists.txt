cmake_minimum_required(VERSION 2.6)

project(mbc_project)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")

# Remember to run symlink in top folder
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)

add_subdirectory(learning)

add_subdirectory(tests)
