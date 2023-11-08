set(PROFILER_SOURCES
    src/ini.c
    src/ImGuiContext.cpp
    src/HttpRequest.cpp
    src/BackendGlfw.cpp
    src/RunQueue.cpp
    src/main.cpp
    src/winmainArchDiscovery.cpp
    src/winmain.cpp
    src/WindowPosition.cpp
    src/ResolvService.cpp
    src/Fonts.cpp
    src/ConnectionHistory.cpp
    src/IsElevated.cpp
    src/Filters.cpp
)

add_executable(profiler ${PROFILER_SOURCES})
target_link_libraries(profiler PUBLIC
    TracyServer
    getopt
    glfw
    nfd)
target_compile_definitions(profiler PUBLIC IMGUI_ENABLE_FREETYPE)