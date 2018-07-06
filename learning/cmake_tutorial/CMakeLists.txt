cmake_minimum_required(VERSION 2.6)
project(Tutorial)

set(Tutorial_CONST_0 0)
set(Tutorial_CONST_1 1)

configure_file("${PROJECT_SOURCE_DIR}/config/TutorialConfig.config"
               "${PROJECT_BINARY_DIR}/config/TutorialConfig.hpp")

configure_file("${PROJECT_SOURCE_DIR}/config/TutorialConfig2.config"
               "${PROJECT_BINARY_DIR}/config/TutorialConfig2.hpp")

# add binary directory to the search tree to find TutorialConfig.hpp
include_directories("${PROJECT_BINARY_DIR}/config")

option(USE_TESTLIB1
       "use testlib1, else use testlib2" ON)

include_directories("${PROJECT_SOURCE_DIR}/TestLibrary")
include_directories("${PROJECT_SOURCE_DIR}/TestLibrary2")

if(USE_TESTLIB1)
    add_subdirectory(TestLibrary)
    set(EXTRA_LIBS ${EXTRA_LIBS} testlib)
else(USE_TESTLIB1)
    add_subdirectory(TestLibrary2)
    set(EXTRA_LIBS ${EXTRA_LIBS} testlib2)
endif(USE_TESTLIB1)

add_executable(tutorial.exe tutorial.cpp)
target_link_libraries(tutorial.exe ${EXTRA_LIBS})

# add the install targets; adds to /usr/local/bin and /use/local/include
#install(TARGETS tutorial.exe DESTINATION bin)
#install(FILES "${PROJECT_BINARY_DIR}/config/TutorialConfig.hpp"
        DESTINATION include)
