project(FATFS)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

file(GLOB FATFS_SOURCES "ff.c" "ffunicode.c" ${FATFS_CFG_H})

add_library(${PROJECT_NAME} ${FATFS_SOURCES})