add_executable(import-fuchsia src/import-fuchsia.cpp)
target_link_libraries(import-fuchsia PUBLIC
    TracyServerNoStatistics
    getopt)

tracy__configure_target(import-fuchsia)