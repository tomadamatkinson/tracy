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

set(TRACY_NO_STATS_FILES
    TracyPrint.cpp
    TracyWorker.cpp
    TracyThreadCompress.cpp
    TracyMemory.cpp
    TracyTextureCompression.cpp
    TracyTaskDispatch.cpp
    TracyMmap.cpp
)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# Utils do not need stats
if (TRACY_BUILD_TARGET_UTILS)
    set(TRACY_SERVER_SOURCE ${TRACY_NO_STATS_FILES})
else()
    set(TRACY_SERVER_SOURCE ${TRACY_SERVER_FILES})
endif()

message("CAPSTONE_LIBRARIES: ${CAPSTONE_LIBRARIES}")

# Tracy Server
add_library(TracyServer STATIC ${TRACY_SERVER_SOURCE})
target_include_directories(TracyServer PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/.. ${CAPSTONE_INCLUDE_DIRS})
target_link_libraries(TracyServer PUBLIC
    TracyClient
    imgui
    imgui_backend
    zstd
    ${CAPSTONE_LIBRARIES}
    Threads::Threads)

# Force windows to link incase not using MSVC
if (WIN32 AND NOT EMSCRIPTEN)
    target_link_libraries(TracyServer PUBLIC wsock32 ws2_32)
endif()

if (NOT EMSCRIPTEN)
    target_link_libraries(TracyServer PUBLIC ${TBB_LIBRARIES} nfd)
endif()

# Utils do not need stats
if (TRACY_BUILD_TARGET_UTILS)
    target_compile_definitions(TracyServer PUBLIC TRACY_ENABLE=0 TRACY_NO_STATISTICS=1)
endif()

