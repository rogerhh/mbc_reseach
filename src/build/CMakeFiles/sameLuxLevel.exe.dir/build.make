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
CMAKE_SOURCE_DIR = /home/rogerhh/mbc_reseach/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/rogerhh/mbc_reseach/src/build

# Include any dependencies generated for this target.
include CMakeFiles/sameLuxLevel.exe.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/sameLuxLevel.exe.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/sameLuxLevel.exe.dir/flags.make

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o: CMakeFiles/sameLuxLevel.exe.dir/flags.make
CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o: ../sameLuxLevel.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/rogerhh/mbc_reseach/src/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o -c /home/rogerhh/mbc_reseach/src/sameLuxLevel.cpp

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/rogerhh/mbc_reseach/src/sameLuxLevel.cpp > CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.i

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/rogerhh/mbc_reseach/src/sameLuxLevel.cpp -o CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.s

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.requires:

.PHONY : CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.requires

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.provides: CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.requires
	$(MAKE) -f CMakeFiles/sameLuxLevel.exe.dir/build.make CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.provides.build
.PHONY : CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.provides

CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.provides.build: CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o


# Object files for target sameLuxLevel.exe
sameLuxLevel_exe_OBJECTS = \
"CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o"

# External object files for target sameLuxLevel.exe
sameLuxLevel_exe_EXTERNAL_OBJECTS =

sameLuxLevel.exe: CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o
sameLuxLevel.exe: CMakeFiles/sameLuxLevel.exe.dir/build.make
sameLuxLevel.exe: CMakeFiles/sameLuxLevel.exe.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/rogerhh/mbc_reseach/src/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable sameLuxLevel.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sameLuxLevel.exe.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/sameLuxLevel.exe.dir/build: sameLuxLevel.exe

.PHONY : CMakeFiles/sameLuxLevel.exe.dir/build

CMakeFiles/sameLuxLevel.exe.dir/requires: CMakeFiles/sameLuxLevel.exe.dir/sameLuxLevel.cpp.o.requires

.PHONY : CMakeFiles/sameLuxLevel.exe.dir/requires

CMakeFiles/sameLuxLevel.exe.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/sameLuxLevel.exe.dir/cmake_clean.cmake
.PHONY : CMakeFiles/sameLuxLevel.exe.dir/clean

CMakeFiles/sameLuxLevel.exe.dir/depend:
	cd /home/rogerhh/mbc_reseach/src/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/rogerhh/mbc_reseach/src /home/rogerhh/mbc_reseach/src /home/rogerhh/mbc_reseach/src/build /home/rogerhh/mbc_reseach/src/build /home/rogerhh/mbc_reseach/src/build/CMakeFiles/sameLuxLevel.exe.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/sameLuxLevel.exe.dir/depend

