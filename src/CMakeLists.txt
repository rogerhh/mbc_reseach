add_library(libmbc
            DataPoint.cpp
            WeatherData.cpp
            SunriseSunsetData.cpp
            MBCFunctions.cpp)

target_link_libraries(libmbc
                      sqlite3
                      curl)

add_executable(read_data_into_database.exe
               read_data_into_database.cpp)

target_link_libraries(read_data_into_database.exe
                      libmbc)

add_executable(bind_test.exe
               bind_test.cpp)

target_link_libraries(bind_test.exe
                      libmbc)
