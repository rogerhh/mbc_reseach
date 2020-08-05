cmake_minimum_required(VERSION 2.8.5)

project(mbc_project)

set(MBC_SOURCE_DIR "${PROJECT_SOURCE_DIR}")
set(WEATHERBIT_API_KEY "8942e41ad9544b3fb9e4f061b01aa5e7")

configure_file("${PROJECT_SOURCE_DIR}/config/mbc_config.config"
               "${PROJECT_SOURCE_DIR}/src/mbc_config.hpp")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread -g -fwrapv -O3 -Wall -Wstrict-prototypes -g -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -fPIC -DMAJOR_VERSION=1 -DMINOR_VERSION=0") # -I/usr/include/python3.5")

# Remember to run symlink in top folder
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)

add_subdirectory(learning)

add_subdirectory(tests)
