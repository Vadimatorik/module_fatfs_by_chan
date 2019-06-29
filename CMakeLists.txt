# Минимально необходимая для сборки версия cmake.
CMAKE_MINIMUM_REQUIRED(VERSION 3.13.2)

# Имя библиотеки.
project(FATFS)

# Производится проверка на то, что параметры оптимизации
# проекта (библиотеки) заданы.
# Они должны быть заданы в корневом проекте.
# Пример:
# SET (FATFS_OPTIMIZATION_FLAGS "-O0;-g3;")
if (NOT DEFINED ${PROJECT_NAME}_OPTIMIZATION_FLAGS)
    message(FATAL_ERROR
            "The value of the variable <<${PROJECT_NAME}_OPTIMIZATION_FLAGS>> is not specified!")
endif ()

# Производится проверка на то, что параметры аппаратной
# части для компилляции проекта (библиотеки) заданы.
# Они должны быть заданы в корневом проекте.
# Параметры должны быть обязательно разделены через <<;>>.
# Пример:
# SET (FATFS_COMPILER_FLAGS "${COMMON_FLAGS};-std=gnu99;-fshort-enums;")
if (NOT DEFINED ${PROJECT_NAME}_COMPILER_FLAGS)
    message(FATAL_ERROR
            "The value of the variable <<${PROJECT_NAME}_COMPILER_FLAGS>> is not specified!")
endif ()

# Для сборки проекта FATFS требуется обязательно указать путь
# до папки с файлом конфигурации библиотеки FATFS в проекте
# пользователя (в корневом CMakeList).
# Пример:
# SET (FATFS_CFG_H_PATH ${CMAKE_SOURCE_DIR}/cfg)
if (NOT DEFINED ${PROJECT_NAME}_CFG_H_PATH)
    message(FATAL_ERROR
            "The value of the variable <<${PROJECT_NAME}_CFG_H_PATH>> is not specified!")
endif ()

include_directories(
        # Для сборки требуется файл конфигурации библиотеки пользователем в корневом проекте.
        ${${PROJECT_NAME}_CFG_H_PATH}
        ${CMAKE_CURRENT_SOURCE_DIR}/inc
        ${CMAKE_CURRENT_SOURCE_DIR}/fat/inc
)

# Компиляции полежат все <<.c>> файлы из директории src.
file(GLOB ${PROJECT_NAME}_SOURCES
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/fat/src/*.cpp")

# Собираем библиотеку из .obj файлов, полученных из файлов, добавленных выше.
add_library(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_SOURCES})

# Компиляция файлов происходит по флагам из корневого CMakeList.
target_compile_options(${PROJECT_NAME} PRIVATE
        "${${PROJECT_NAME}_COMPILER_FLAGS}${${PROJECT_NAME}_OPTIMIZATION_FLAGS}")

# Показ флагов компиляции.
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMENT
        "${PROJECT_NAME} flags: ${${PROJECT_NAME}_COMPILER_FLAGS}${${PROJECT_NAME}_OPTIMIZATION_FLAGS}")

# Вывод коммита.
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMENT "${PROJECT_NAME} commit:"
        COMMAND git rev-parse HEAD)

# Вывод размера библиотеки.
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        DEPENDS ${PROJECT_NAME}.a
        COMMENT "${PROJECT_NAME} size information:"
        COMMAND cd ${PROJECT_BINARY_DIR}
        COMMAND ${ARM_SIZE} lib${PROJECT_NAME}.a -t)