cmake_minimum_required(VERSION 2.6)

project(mbc_project)

set(MBC_SOURCE_DIR "${PROJECT_SOURCE_DIR}")

configure_file("${PROJECT_SOURCE_DIR}/config/mbc_config.config"
               "${PROJECT_SOURCE_DIR}/src/mbc_config.hpp")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")

# Remember to run symlink in top folder
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)

add_subdirectory(learning)

add_subdirectory(tests)
