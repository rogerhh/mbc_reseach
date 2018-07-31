add_executable(parse_inital_data.exe	parse_initial_data.cpp)
add_executable(sameLuxLevel.exe			sameLuxLevel.cpp)
add_executable(comparison.exe           comparison.cpp)
add_executable(findMax.exe              findMax.cpp)
add_executable(modifyData.exe           modifyData.cpp)

add_executable(read_file.exe            
               read_file.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

target_link_libraries(read_file.exe
                      sqlite3)

add_executable(test_read_from_database.exe
               test_read_from_database.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

target_link_libraries(test_read_from_database.exe
                      sqlite3)

add_executable(test_del_file.exe
               test_del_file.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

target_link_libraries(test_del_file.exe
                      sqlite3)

add_executable(mktime_test.exe
               mktime_test.cpp)

target_link_libraries(mktime_test.exe
                      sqlite3)

add_executable(dump_data.exe
               dump_data.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

target_link_libraries(dump_data.exe
                      sqlite3)

add_executable(read_data_into_database.exe
               read_data_into_database.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

target_link_libraries(read_data_into_database.exe
                      sqlite3)
