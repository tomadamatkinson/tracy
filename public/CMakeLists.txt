find_package(Threads REQUIRED)
if(TRACY_STATIC)
	set(TRACY_VISIBILITY "STATIC")
else()
	set(TRACY_VISIBILITY "SHARED")
endif()

add_library(TracyClient ${TRACY_VISIBILITY} "${TRACY_PUBLIC_DIR}/TracyClient.cpp")
target_include_directories(TracyClient SYSTEM PUBLIC
    $<BUILD_INTERFACE:${TRACY_PUBLIC_DIR}>
    $<INSTALL_INTERFACE:include>)
target_link_libraries(
    TracyClient
    PUBLIC
        Threads::Threads
        ${CMAKE_DL_LIBS}
)

# Public dependency on some libraries required when using Mingw
if(WIN32 AND ${CMAKE_CXX_COMPILER_ID} MATCHES "GNU")
    target_link_libraries(TracyClient PUBLIC ws2_32 dbghelp)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    find_library(EXECINFO_LIBRARY NAMES execinfo REQUIRED)
    target_link_libraries(TracyClient PUBLIC ${EXECINFO_LIBRARY})
endif()

if(NOT TRACY_STATIC)
    target_compile_definitions(TracyClient PRIVATE TRACY_EXPORTS)
    target_compile_definitions(TracyClient PUBLIC TRACY_IMPORTS)
endif()

set_target_properties(TracyClient PROPERTIES VERSION ${PROJECT_VERSION})

add_library(Tracy::TracyClient ALIAS TracyClient)

macro(tracy_compile_definitions target option)
    if(${option})
        target_compile_definitions(${target} PUBLIC ${option})
    endif()
endmacro()

tracy_compile_definitions(TracyClient TRACY_ENABLE)
tracy_compile_definitions(TracyClient TRACY_ON_DEMAND)
tracy_compile_definitions(TracyClient TRACY_CALLSTACK)
tracy_compile_definitions(TracyClient TRACY_NO_CALLSTACK)
tracy_compile_definitions(TracyClient TRACY_NO_CALLSTACK)
tracy_compile_definitions(TracyClient TRACY_NO_CALLSTACK_INLINES)
tracy_compile_definitions(TracyClient TRACY_ONLY_LOCALHOST)
tracy_compile_definitions(TracyClient TRACY_NO_BROADCAST)
tracy_compile_definitions(TracyClient TRACY_ONLY_IPV4)
tracy_compile_definitions(TracyClient TRACY_NO_CODE_TRANSFER)
tracy_compile_definitions(TracyClient TRACY_NO_CONTEXT_SWITCH)
tracy_compile_definitions(TracyClient TRACY_NO_EXIT)
tracy_compile_definitions(TracyClient TRACY_NO_SAMPLING)
tracy_compile_definitions(TracyClient TRACY_NO_VERIFY)
tracy_compile_definitions(TracyClient TRACY_NO_VSYNC_CAPTURE)
tracy_compile_definitions(TracyClient TRACY_NO_FRAME_IMAGE)
tracy_compile_definitions(TracyClient TRACY_NO_SYSTEM_TRACING)
tracy_compile_definitions(TracyClient TRACY_PATCHABLE_NOPSLEDS)
tracy_compile_definitions(TracyClient TRACY_DELAYED_INIT)
tracy_compile_definitions(TracyClient TRACY_MANUAL_LIFETIME)
tracy_compile_definitions(TracyClient TRACY_FIBERS)
tracy_compile_definitions(TracyClient TRACY_NO_CRASH_HANDLER)
tracy_compile_definitions(TracyClient TRACY_TIMER_FALLBACK)
tracy_compile_definitions(TracyClient TRACY_WITH_EXECUTABLES)

## Tracy Client Server Interface

set(TRACY_FILES
    common/tracy_lz4.cpp
    common/tracy_lz4hc.cpp
    common/TracySocket.cpp
    common/TracyStackFrames.cpp
    common/TracySystem.cpp
)

add_library(TracyClientServerInterface STATIC ${TRACY_FILES})
target_include_directories(TracyClientServerInterface SYSTEM PUBLIC
    $<BUILD_INTERFACE:${TRACY_PUBLIC_DIR}>
    $<INSTALL_INTERFACE:include>)
target_link_libraries(
    TracyClientServerInterface
    PUBLIC
        Threads::Threads
        ${CMAKE_DL_LIBS}
)

# Public dependency on some libraries required when using Mingw
if(WIN32 AND ${CMAKE_CXX_COMPILER_ID} MATCHES "GNU")
    target_link_libraries(TracyClientServerInterface PUBLIC ws2_32 dbghelp)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    find_library(EXECINFO_LIBRARY NAMES execinfo REQUIRED)
    target_link_libraries(TracyClientServerInterface PUBLIC ${EXECINFO_LIBRARY})
endif()

if(NOT TRACY_STATIC)
    target_compile_definitions(TracyClientServerInterface PUBLIC TRACY_EXPORTS)
    target_compile_definitions(TracyClientServerInterface PUBLIC TRACY_IMPORTS)
endif()

set_target_properties(TracyClientServerInterface PROPERTIES VERSION ${PROJECT_VERSION})