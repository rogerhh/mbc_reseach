# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/rogerhh/cmake_tutorial

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/rogerhh/cmake_tutorial/build

# Include any dependencies generated for this target.
include CMakeFiles/tutorial.exe.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/tutorial.exe.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/tutorial.exe.dir/flags.make

CMakeFiles/tutorial.exe.dir/tutorial.cpp.o: CMakeFiles/tutorial.exe.dir/flags.make
CMakeFiles/tutorial.exe.dir/tutorial.cpp.o: ../tutorial.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/rogerhh/cmake_tutorial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/tutorial.exe.dir/tutorial.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tutorial.exe.dir/tutorial.cpp.o -c /home/rogerhh/cmake_tutorial/tutorial.cpp

CMakeFiles/tutorial.exe.dir/tutorial.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tutorial.exe.dir/tutorial.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/rogerhh/cmake_tutorial/tutorial.cpp > CMakeFiles/tutorial.exe.dir/tutorial.cpp.i

CMakeFiles/tutorial.exe.dir/tutorial.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tutorial.exe.dir/tutorial.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/rogerhh/cmake_tutorial/tutorial.cpp -o CMakeFiles/tutorial.exe.dir/tutorial.cpp.s

CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.requires:

.PHONY : CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.requires

CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.provides: CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.requires
	$(MAKE) -f CMakeFiles/tutorial.exe.dir/build.make CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.provides.build
.PHONY : CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.provides

CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.provides.build: CMakeFiles/tutorial.exe.dir/tutorial.cpp.o


# Object files for target tutorial.exe
tutorial_exe_OBJECTS = \
"CMakeFiles/tutorial.exe.dir/tutorial.cpp.o"

# External object files for target tutorial.exe
tutorial_exe_EXTERNAL_OBJECTS =

tutorial.exe: CMakeFiles/tutorial.exe.dir/tutorial.cpp.o
tutorial.exe: CMakeFiles/tutorial.exe.dir/build.make
tutorial.exe: TestLibrary2/libtestlib2.a
tutorial.exe: CMakeFiles/tutorial.exe.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/rogerhh/cmake_tutorial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable tutorial.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/tutorial.exe.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/tutorial.exe.dir/build: tutorial.exe

.PHONY : CMakeFiles/tutorial.exe.dir/build

CMakeFiles/tutorial.exe.dir/requires: CMakeFiles/tutorial.exe.dir/tutorial.cpp.o.requires

.PHONY : CMakeFiles/tutorial.exe.dir/requires

CMakeFiles/tutorial.exe.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/tutorial.exe.dir/cmake_clean.cmake
.PHONY : CMakeFiles/tutorial.exe.dir/clean

CMakeFiles/tutorial.exe.dir/depend:
	cd /home/rogerhh/cmake_tutorial/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/rogerhh/cmake_tutorial /home/rogerhh/cmake_tutorial /home/rogerhh/cmake_tutorial/build /home/rogerhh/cmake_tutorial/build /home/rogerhh/cmake_tutorial/build/CMakeFiles/tutorial.exe.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/tutorial.exe.dir/depend

