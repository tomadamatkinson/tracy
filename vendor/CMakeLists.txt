CPMAddPackage("gh:capstone-engine/capstone#5.0.1")
CPMAddPackage("gh:freetype/freetype#VER-2-13-2")
CPMAddPackage("gh:glfw/glfw#3.3.4")

CPMAddPackage(
    NAME tbb
    GITHUB_REPOSITORY oneapi-src/oneTBB
    GIT_TAG v2021.4.1
    OPTIONS "TBB_TEST OFF"
)

find_package(freetype REQUIRED)

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
    target_link_libraries(imgui PUBLIC freetype)
endif()

add_library(imgui_backend STATIC 
    imgui_backend/imgui_impl_glfw.cpp
    imgui_backend/imgui_impl_opengl3.cpp)
target_link_libraries(imgui_backend PUBLIC imgui glfw)
target_include_directories(imgui_backend PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${GLFW_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR}/imgui_backend)

if (NOT TRACY_NO_FILESELECTOR)
    CPMAddPackage("gh:btzy/nativefiledialog-extended#v1.1.1")
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
