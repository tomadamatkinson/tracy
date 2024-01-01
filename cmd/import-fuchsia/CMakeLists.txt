add_executable(import-fuchsia src/import-fuchsia.cpp)
target_link_libraries(import-fuchsia PUBLIC
    TracyServerNoStatistics
    getopt)
target_compile_definitions(import-fuchsia PUBLIC TRACY_NO_STATISTICS=1)