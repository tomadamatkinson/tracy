set(CMAKE_CC_COMPILER emcc)
set(CMAKE_CXX_COMPILER em++)

add_compile_definitions(TRACY_NO_ISA_EXTENSIONS=1)

file(DOWNLOAD "https://share.nereid.pl/i/embed.tracy")