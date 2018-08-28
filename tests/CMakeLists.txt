link_directories(${CMAKE_SOURCE_DIR}/src)

add_executable(select_datapoints_test.exe
               select_datapoints_test.cpp
               unit_test_framework.cpp)

target_link_libraries(select_datapoints_test.exe
                      libmbc)

add_executable(sunrise_sunset_test.exe
               sunrise_sunset_test.cpp
               unit_test_framework.cpp)

target_link_libraries(sunrise_sunset_test.exe
                      libmbc)

add_executable(get_weather_data_test.exe
               get_weather_data_test.cpp
               unit_test_framework.cpp)

target_link_libraries(get_weather_data_test.exe
                      libmbc)
