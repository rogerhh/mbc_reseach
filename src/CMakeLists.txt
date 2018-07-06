add_executable(parse_inital_data.exe	parse_initial_data.cpp)
add_executable(sameLuxLevel.exe			sameLuxLevel.cpp)
add_executable(comparison.exe           comparison.cpp)
add_executable(findMax.exe              findMax.cpp)
add_executable(modifyData.exe           modifyData.cpp)
add_executable(read_file.exe            
               read_file.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

add_executable(test_read_from_database.exe
               test_read_from_database.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

add_executable(test_del_file.exe
               test_del_file.cpp
               DataPoint.cpp
               MBCFunctions.cpp)

add_executable(mktime_test.exe
               mktime_test.cpp)
