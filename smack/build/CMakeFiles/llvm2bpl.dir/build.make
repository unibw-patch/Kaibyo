# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

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
CMAKE_SOURCE_DIR = /home/ponce/tools/smack

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ponce/tools/smack/build

# Include any dependencies generated for this target.
include CMakeFiles/llvm2bpl.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/llvm2bpl.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/llvm2bpl.dir/flags.make

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o: CMakeFiles/llvm2bpl.dir/flags.make
CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o: ../tools/llvm2bpl/llvm2bpl.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ponce/tools/smack/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o"
	/usr/bin/clang++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o -c /home/ponce/tools/smack/tools/llvm2bpl/llvm2bpl.cpp

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.i"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ponce/tools/smack/tools/llvm2bpl/llvm2bpl.cpp > CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.i

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.s"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ponce/tools/smack/tools/llvm2bpl/llvm2bpl.cpp -o CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.s

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.requires:

.PHONY : CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.requires

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.provides: CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.requires
	$(MAKE) -f CMakeFiles/llvm2bpl.dir/build.make CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.provides.build
.PHONY : CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.provides

CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.provides.build: CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o


# Object files for target llvm2bpl
llvm2bpl_OBJECTS = \
"CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o"

# External object files for target llvm2bpl
llvm2bpl_EXTERNAL_OBJECTS =

llvm2bpl: CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o
llvm2bpl: CMakeFiles/llvm2bpl.dir/build.make
llvm2bpl: libsmackTranslator.a
llvm2bpl: libassistDS.a
llvm2bpl: libdsa.a
llvm2bpl: CMakeFiles/llvm2bpl.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/ponce/tools/smack/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable llvm2bpl"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llvm2bpl.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/llvm2bpl.dir/build: llvm2bpl

.PHONY : CMakeFiles/llvm2bpl.dir/build

CMakeFiles/llvm2bpl.dir/requires: CMakeFiles/llvm2bpl.dir/tools/llvm2bpl/llvm2bpl.cpp.o.requires

.PHONY : CMakeFiles/llvm2bpl.dir/requires

CMakeFiles/llvm2bpl.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/llvm2bpl.dir/cmake_clean.cmake
.PHONY : CMakeFiles/llvm2bpl.dir/clean

CMakeFiles/llvm2bpl.dir/depend:
	cd /home/ponce/tools/smack/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ponce/tools/smack /home/ponce/tools/smack /home/ponce/tools/smack/build /home/ponce/tools/smack/build /home/ponce/tools/smack/build/CMakeFiles/llvm2bpl.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/llvm2bpl.dir/depend

