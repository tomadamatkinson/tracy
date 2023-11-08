add_executable(capture src/capture.cpp)
target_link_libraries(capture PUBLIC
    TracyServerNoStatistics
    getopt)
target_compile_definitions(capture PUBLIC TRACY_NO_STATISTICS=1)