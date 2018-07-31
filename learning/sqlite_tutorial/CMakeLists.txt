add_executable(sqlite_test.exe
               sqlite_test.cpp)

target_link_libraries(sqlite_test.exe
                      sqlite3)
