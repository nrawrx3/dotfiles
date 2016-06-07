
project(whatever)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)
add_compile_options("-std=c++14")
add_executable(${PROJECT_NAME} ${SRC_LIST})

# Two pretty common libraries

# pthread
find_package(Threads)
target_link_libraries (${PROJECT_NAME} ${CMAKE_THREAD_LIBS_INIT})

# boost
set(Boost_USE_MULTITHREADED ON)
find_package(Boost COMPONENTS date_time filesystem system)
if (Boost_FOUND)
    message("Boost version - ${Boost_VERSION}")
    message("Boost include dirs - ${Boost_INCLUDE_DIRS}")
    message("Boost libraries - ${Boost_LIBRARIES}")
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
    TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES})
endif (Boost_FOUND)

# websocketpp - header only library
INCLUDE_DIRECTORIES("websocketpp")

# leveldb - (How to link a separately compiled library)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} "/home/snyp/gits/leveldb/out-static/libleveldb.a")
TARGET_LINK_LIBRARIES(${PROJECT_NAME} "/usr/lib/libsnappy.so")
