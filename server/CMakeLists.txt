set(TRACY_SERVER_FILES
    TracyEventDebug.cpp
    TracyTimelineController.cpp
    TracyView_Playback.cpp
    TracyTexture.cpp
    TracyView_Locks.cpp
    TracyView_Memory.cpp
    TracyFileselector.cpp
    TracyView_Compare.cpp
    TracyView_ZoneInfo.cpp
    TracyView_Callstack.cpp
    TracySourceContents.cpp
    TracyPrint.cpp
    TracyStorage.cpp
    TracyTextureCompression.cpp
    TracySourceView.cpp
    TracyView_ContextSwitch.cpp
    TracyUserData.cpp
    TracySourceTokenizer.cpp
    TracyView_Statistics.cpp
    TracyView_Timeline.cpp
    TracyUtility.cpp
    TracyTimelineItemCpuData.cpp
    TracyView_FrameTree.cpp
    TracyMicroArchitecture.cpp
    TracyView_Ranges.cpp
    TracyView.cpp
    TracyMemory.cpp
    TracyView_ConnectionState.cpp
    TracyView_Navigation.cpp
    TracyView_Utility.cpp
    TracyView_Plots.cpp
    TracyProtoHistory.cpp
    TracyView_FrameTimeline.cpp
    TracyView_FindZone.cpp
    TracyThreadCompress.cpp
    TracyImGui.cpp
    TracyView_GpuTimeline.cpp
    TracyTaskDispatch.cpp
    TracyTimelineItemThread.cpp
    TracyTimelineItemPlot.cpp
    TracyWeb.cpp
    TracyTimelineItem.cpp
    TracyColor.cpp
    TracyWorker.cpp
    TracyView_FrameOverview.cpp
    TracyView_Samples.cpp
    TracyMouse.cpp
    TracyView_Messages.cpp
    TracyMmap.cpp
    TracyView_ZoneTimeline.cpp
    TracyView_Annotations.cpp
    TracyFilesystem.cpp
    TracyView_TraceInfo.cpp
    TracyView_NotificationArea.cpp
    TracyTimelineItemGpu.cpp
    TracyView_CpuData.cpp
    TracyBadVersion.cpp
    TracyView_Options.cpp
)

find_package(Threads REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(CAPSTONE REQUIRED IMPORTED_TARGET capstone)
pkg_check_modules(TBB REQUIRED IMPORTED_TARGET tbb)

# Tracy Server
add_library(TracyServer STATIC ${TRACY_SERVER_FILES})
target_include_directories(TracyServer PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(TracyServer PUBLIC
    TracyClientServerInterface
    imgui
    imgui_backend
    zstd
    nfd
    PkgConfig::CAPSTONE
    PkgConfig::TBB
    ${CMAKE_THREAD_LIBS_INIT})

set(TRACY_NO_STATS_FILES
    TracyPrint.cpp
    TracyWorker.cpp
    TracyThreadCompress.cpp
    TracyMemory.cpp
    TracyTextureCompression.cpp
    TracyTaskDispatch.cpp
    TracyMmap.cpp
)

# Tracy Server without statistics
add_library(TracyServerNoStatistics STATIC ${TRACY_NO_STATS_FILES})
target_include_directories(TracyServerNoStatistics PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(TracyServerNoStatistics PUBLIC
    TracyClientServerInterface
    imgui
    imgui_backend
    zstd
    nfd
    PkgConfig::CAPSTONE
    PkgConfig::TBB
    ${CMAKE_THREAD_LIBS_INIT})
target_compile_definitions(TracyServerNoStatistics PUBLIC TRACY_ENABLE=0 TRACY_NO_STATISTICS=1)

if (WIN32)
    target_link_libraries(TracyServer PUBLIC wsock32 ws2_32)
    target_link_libraries(TracyServerNoStatistics PUBLIC wsock32 ws2_32)
endif()