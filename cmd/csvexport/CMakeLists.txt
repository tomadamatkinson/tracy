add_executable(csvexport src/csvexport.cpp)
target_link_libraries(csvexport PUBLIC
    TracyServer
    getopt)
