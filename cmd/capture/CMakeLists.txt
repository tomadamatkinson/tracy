add_executable(capture src/capture.cpp)
target_link_libraries(capture PUBLIC
    TracyServer # No stats set by TRACY_BUILD_TARGET_UTILS
    getopt)

tracy__configure_target(capture)