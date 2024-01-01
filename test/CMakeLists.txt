
add_executable(tracy_test test.cpp)
target_include_directories(tracy_test PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(tracy_test PUBLIC TracyClient)
target_compile_definitions(tracy_test PUBLIC TRACY_ENABLE=1)