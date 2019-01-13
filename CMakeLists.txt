project(FATFS)

include_directories(
    ${CMAKE_SOURCE_DIR}/cfg
    ${CMAKE_CURRENT_SOURCE_DIR}
)

file(GLOB FATFS_SOURCES "*.c")

add_library(${PROJECT_NAME} ${FATFS_SOURCES})