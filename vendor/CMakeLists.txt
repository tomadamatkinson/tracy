include(FindPkgConfig)

if (NOT PKG_CONFIG_FOUND)
    message(WARN "pkg-config not found, forcing fetch of dependencies")
endif()

# Determin which dependencies need to be fetched
if (TRACY_FORCE_FETCH_DEPENDENCIES OR NOT PKG_CONFIG_FOUND)
    set(PULL_CAPSTONE ON)
    set(PULL_FREETYPE ON)
    set(PULL_GLFW ON)
    set(PULL_TBB ON)
else()
    macro(find_or_fetch pkg_alias pkg_name)
    # Check for system dependencies first
        pkg_check_modules(${pkg_alias} ${pkg_name})
        if (NOT ${pkg_alias}_FOUND)
            set(PULL_${pkg_alias} ON)
        else()
            message(STATUS "Using system ${pkg_name} ${${pkg_alias}_VERSION}")
        endif()
    endmacro()

    find_or_fetch(CAPSTONE capstone)
    find_or_fetch(FREETYPE freetype2)
    find_or_fetch(GLFW glfw3)
    find_or_fetch(TBB tbb)
endif()

if (PULL_CAPSTONE)
    CPMAddPackage("gh:capstone-engine/capstone#5.0.1")
    set(CAPSTONE_LIBRARIES capstone PARENT_SCOPE)
endif()


if ("${CAPSTONE_INCLUDE_DIRS}" STREQUAL "/usr/include/capstone")
    # In source we use <capstone/capstone.h>
    # This is a workaround for capstone installations that pass -I/usr/include/capstone to the compiler
    list(APPEND CAPSTONE_INCLUDE_DIRS "/usr/include")
endif()

if (PULL_FREETYPE)
    CPMAddPackage("gh:freetype/freetype#VER-2-13-2")
    set(FREETYPE_LIBRARIES freetype)
endif()

if (NOT EMSCRIPTEN AND PULL_GLFW)
    CPMAddPackage("gh:glfw/glfw#3.3.9")
    set(GLFW_LIBRARIES glfw)
endif()

if (NOT EMSCRIPTEN AND UNIX AND PULL_TBB)
    CPMAddPackage(
        NAME tbb
        GITHUB_REPOSITORY oneapi-src/oneTBB
        GIT_TAG v2021.4.1
        OPTIONS "TBB_TEST OFF"
    )
    set(TBB_LIBRARIES tbb)
endif()

CPMAddPackage("gh:btzy/nativefiledialog-extended#v1.1.1")

# Static declarations to vendors are required as these vendors have been modified to fit the needs of this project.
# https://github.com/cubicdaiya/dtl
add_library(dlt INTERFACE)
target_include_directories(dlt INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/)

# Static declarations to vendors are required as these vendors have been modified to fit the needs of this project.
# https://github.com/kimgr/getopt_port
add_library(getopt STATIC getopt/getopt.c)
target_include_directories(getopt PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/getopt)
set_target_properties(getopt PROPERTIES LINKER_LANGUAGE C)

set(IMGUI_FILES
    imgui/imgui_draw.cpp
    imgui/imgui_tables.cpp
    imgui/imgui_widgets.cpp
    imgui/imgui.cpp
)

if (IMGUI_ENABLE_FREETYPE)
    list(APPEND IMGUI_FILES imgui/misc/freetype/imgui_freetype.cpp)
endif()

add_library(imgui STATIC ${IMGUI_FILES})
target_include_directories(imgui PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/imgui)

if (IMGUI_ENABLE_FREETYPE)
    target_link_libraries(imgui PUBLIC ${FREETYPE_LIBRARIES})
endif()

add_library(imgui_backend STATIC 
    imgui_backend/imgui_impl_glfw.cpp
    imgui_backend/imgui_impl_opengl3.cpp)
target_link_libraries(imgui_backend PUBLIC imgui glfw)
target_include_directories(imgui_backend PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${GLFW_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR}/imgui_backend)
if (EMSCRIPTEN)
    target_compile_definitions(imgui_backend PUBLIC IMGUI_ENABLE_FREETYPE IMGUI_IMPL_OPENGL_ES2)
endif()

# Static declarations to vendors are required as these vendors have been modified to fit the needs of this project.
# https://github.com/facebook/zstd
set(ZSTD_FILES
    zstd/decompress/huf_decompress_amd64.S
    zstd/decompress/zstd_ddict.c
    zstd/decompress/zstd_decompress_block.c
    zstd/decompress/huf_decompress.c
    zstd/decompress/zstd_decompress.c
    zstd/common/zstd_common.c
    zstd/common/error_private.c
    zstd/common/xxhash.c
    zstd/common/entropy_common.c
    zstd/common/debug.c
    zstd/common/threading.c
    zstd/common/pool.c
    zstd/common/fse_decompress.c
    zstd/compress/zstd_ldm.c
    zstd/compress/zstd_compress_superblock.c
    zstd/compress/zstd_opt.c
    zstd/compress/zstd_compress_sequences.c
    zstd/compress/fse_compress.c
    zstd/compress/zstd_double_fast.c
    zstd/compress/zstd_compress.c
    zstd/compress/zstd_compress_literals.c
    zstd/compress/hist.c
    zstd/compress/zstdmt_compress.c
    zstd/compress/zstd_lazy.c
    zstd/compress/huf_compress.c
    zstd/compress/zstd_fast.c
    zstd/dictBuilder/zdict.c
    zstd/dictBuilder/cover.c
    zstd/dictBuilder/divsufsort.c
    zstd/dictBuilder/fastcover.c
)
add_library(zstd STATIC ${ZSTD_FILES})
target_include_directories(zstd PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/zstd)
set_target_properties(zstd PROPERTIES LINKER_LANGUAGE C)
