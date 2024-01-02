add_custom_target(tracy_executables)

if (TRACY_BUILD_TARGET_PROFILER)
    add_subdirectory(profiler)
    add_dependencies(tracy_executables profiler)

    # Also relies on stats existing
    add_subdirectory(csvexport)
    add_dependencies(tracy_executables csvexport)
endif()

if (TRACY_BUILD_TARGET_UTILS)
    # Require no stats
    add_subdirectory(capture)
    add_dependencies(tracy_executables capture)

    add_subdirectory(import-chrome)
    add_dependencies(tracy_executables import-chrome)

    add_subdirectory(import-fuchsia)
    add_dependencies(tracy_executables import-fuchsia)

    add_subdirectory(update)
    add_dependencies(tracy_executables update)
endif()