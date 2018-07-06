add_executable(socket_client.exe 
               socket_client.cpp)

add_executable(socket_server.exe
               socket_server.cpp)

add_executable(http_tutorial.exe
               http_tutorial.cpp)

add_executable(http_get_tutorial.exe
               http_get_tutorial.cpp)

add_executable(curl_test.exe
               curl_test.cpp)

target_link_libraries(curl_test.exe
                      curl)
