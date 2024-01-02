add_executable(import-fuchsia src/import-fuchsia.cpp)
target_link_libraries(import-fuchsia PUBLIC
    TracyServer # No stats set by TRACY_BUILD_TARGET_UTILS
    getopt)

tracy__configure_target(import-fuchsia)