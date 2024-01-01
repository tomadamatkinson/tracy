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
    imgui_backend)
target_compile_definitions(profiler PUBLIC IMGUI_ENABLE_FREETYPE)
set_target_properties(profiler PROPERTIES OUTPUT_NAME "tracy")

if (EMSCRIPTEN)
    file(COPY wasm/httpd.py DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    file(COPY wasm/index.html DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/embed.tracy
        COMMAND wget "https://share.nereid.pl/i/embed.tracy" -O ${CMAKE_CURRENT_BINARY_DIR}/embed.tracy
    )
    add_custom_target(embed_tracy ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/embed.tracy)
    add_dependencies(profiler embed_tracy)
    set(EM_LINK_FLAGS "-pthread -sUSE_PTHREADS=1 -sUSE_GLFW=3 -sINITIAL_MEMORY=384mb -sALLOW_MEMORY_GROWTH=1 -sMAXIMUM_MEMORY=4gb -sWASM_BIGINT=1 -sPTHREAD_POOL_SIZE=4 -sEXPORTED_FUNCTIONS=_main,_nativeResize,_nativeOpenFile -sEXPORTED_RUNTIME_METHODS=ccall -sENVIRONMENT=web,worker -sASSERTIONS=1 --preload-file ${CMAKE_CURRENT_BINARY_DIR}/embed.tracy@embed.tracy")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EM_LINK_FLAGS}")
 endif()