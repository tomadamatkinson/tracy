add_executable(import-chrome src/import-chrome.cpp)
target_link_libraries(import-chrome PUBLIC
    TracyServerNoStatistics
    getopt)

tracy__configure_target(import-chrome)