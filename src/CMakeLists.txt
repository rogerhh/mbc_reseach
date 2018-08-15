add_library(libmbc
            DataPoint.cpp
            WeatherData.cpp
            MBCFunctions.cpp)

add_executable(read_data_into_database.exe
               read_data_into_database.cpp)

target_link_libraries(read_data_into_database.exe
                      libmbc
                      sqlite3)
