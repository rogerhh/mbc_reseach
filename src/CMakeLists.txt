add_library(libmbc
            DataPoint.cpp
            WeatherData.cpp
            SunriseSunsetData.cpp
            json11.cpp
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

add_executable(get_sun_data.exe
               get_sun_data.cpp)

target_link_libraries(get_sun_data.exe
                      libmbc)

add_executable(sort_valid_data.exe
               sort_valid_data.cpp)

target_link_libraries(sort_valid_data.exe
                      libmbc)

add_executable(sort_locations.exe
               sort_locations.cpp)

target_link_libraries(sort_locations.exe
                      libmbc)

add_executable(weatherStation weather_data_module.cpp DataPoint.cpp WeatherData.cpp SunriseSunsetData.cpp json11.cpp MBCFunctions.cpp)
target_link_libraries(weatherStation sqlite3 curl)

