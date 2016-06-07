project(luastuff)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wall -Wextra")

# pthread
find_package(Threads)
#target_link_libraries (luastuff ${CMAKE_THREAD_LIBS_INIT})


# Have scaffold as a subdirectory
add_subdirectory(scaffold)
include_directories(scaffold/src)
#target_link_libraries(luastuff scaffold)

# And also the lua source files
add_subdirectory(lua)
include_directories(lua)
#target_link_libraries(luastuff lua)

