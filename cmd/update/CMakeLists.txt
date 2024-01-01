set(UPDATE_SOURCES
    src/OfflineSymbolResolver.cpp
    src/OfflineSymbolResolver.h
    src/OfflineSymbolResolverAddr2Line.cpp
    src/OfflineSymbolResolverDbgHelper.cpp
    src/update.cpp
)

add_executable(update ${UPDATE_SOURCES})
target_link_libraries(update PUBLIC
    TracyServer
    getopt)