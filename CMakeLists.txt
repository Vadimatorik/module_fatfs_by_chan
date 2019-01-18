# Минимально необходимая для сборки версия cmake.
CMAKE_MINIMUM_REQUIRED(VERSION 3.13.2)

# Имя библиотеки.
project(FATFS)

# Производится проверка на то, что параметры оптимизации
# проекта (библиотеки) заданы.
# Они должны быть заданы в корневом проекте.
# Пример:
# SET (FATFS_OPTIMIZATION_FLAGS "-O0;-g3;")
if (NOT DEFINED FATFS_OPTIMIZATION_FLAGS)
    message(FATAL_ERROR "The value of the variable <<FATFS_OPTIMIZATION_FLAGS>> is not specified!")
endif ()

# Производится проверка на то, что параметры аппаратной
# части для компилляции проекта (библиотеки) заданы.
# Они должны быть заданы в корневом проекте.
# Параметры должны быть обязательно разделены через <<;>>.
# Пример:
# SET (FATFS_COMPILER_FLAGS "${COMMON_FLAGS};-std=gnu99;-fshort-enums;")
if (NOT DEFINED FATFS_COMPILER_FLAGS)
    message(FATAL_ERROR "The value of the variable <<FATFS_COMPILER_FLAGS>> is not specified!")
endif ()

# Для сборки проекта FATFS требуется обязательно указать путь
# до папки с файлом конфигурации библиотеки FATFS в проекте
# пользователя (в корневом CMakeList).
# Пример:
# SET (FATFS_CFG_H_PATH ${CMAKE_SOURCE_DIR}/cfg)
if (NOT DEFINED FATFS_CFG_H_PATH)
    message(FATAL_ERROR "The value of the variable <<FATFS_CFG_H_PATH>> is not specified!")
endif()

include_directories(
    # Для сборки требуется файл конфигурации библиотеки пользователем в корневом проекте.
    ${FATFS_CFG_H_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

# Компиляции полежат все <<.c>> файлы из директории src.
file(GLOB FATFS_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c")

# Собираем библиотеку из .obj файлов, полученных из файлов, добавленных выше.
add_library(${PROJECT_NAME} ${FATFS_SOURCES})

# Компиляция файлов происходит по флагам из корневого CMakeList.
target_compile_options(${PROJECT_NAME} PRIVATE "${FATFS_COMPILER_FLAGS}${FATFS_OPTIMIZATION_FLAGS}")

# Показ флагов компиляции.
add_custom_command (TARGET ${PROJECT_NAME} POST_BUILD
                    COMMENT "${PROJECT_NAME} flags: ${FATFS_COMPILER_FLAGS}${FATFS_OPTIMIZATION_FLAGS}")

# Вывод коммита.
add_custom_command (TARGET ${PROJECT_NAME} POST_BUILD
                    COMMENT "${PROJECT_NAME} commit:"
                    COMMAND git rev-parse HEAD)

# Вывод размера библиотеки.
add_custom_command (TARGET ${PROJECT_NAME} POST_BUILD
                    DEPENDS ${PROJECT_NAME}.a
                    COMMENT "${PROJECT_NAME} size information:"
                    COMMAND cd ${PROJECT_BINARY_DIR}
                    COMMAND ${ARM_SIZE} lib${PROJECT_NAME}.a -t)


