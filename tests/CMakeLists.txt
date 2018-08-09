link_directories(${CMAKE_SOURCE_DIR}/src)

add_executable(select_datapoints_test.exe
               select_datapoints_test.cpp)

target_link_libraries(select_datapoints_test.exe
                      libmbc
                      sqlite3)
