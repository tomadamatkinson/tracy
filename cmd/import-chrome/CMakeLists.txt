add_executable(import-chrome src/import-chrome.cpp)
target_link_libraries(import-chrome PUBLIC
    TracyServerNoStatistics
    getopt)
target_compile_definitions(import-chrome PUBLIC TRACY_NO_STATISTICS=1)