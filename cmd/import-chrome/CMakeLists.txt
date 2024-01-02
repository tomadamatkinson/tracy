add_executable(import-chrome src/import-chrome.cpp)
target_link_libraries(import-chrome PUBLIC
    TracyServer # No stats set by TRACY_BUILD_TARGET_UTILS
    getopt)

tracy__configure_target(import-chrome)