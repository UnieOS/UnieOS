cmake_minimum_required(VERSION 3.16)
project(UnieOS LANGUAGES C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(unielibc STATIC
    unielibc/main.c
    unielibc/string/memcpy.c
    unielibc/string/strlen.c
    unielibc/asm/write.s
    unielibc/asm/start.s
)

target_include_directories(unielibc PUBLIC
    ${CMAKE_SOURCE_DIR}/unielibc/include
)

add_library(unielibcxx STATIC
    unielibc++/main.cpp
    unielibc++/src/iostream.cpp
    unielibc++/src/string.cpp
    unielibc++/src/asm/write.s
    unielibc++/src/asm/start.s
)

target_include_directories(unielibcxx PUBLIC
    ${CMAKE_SOURCE_DIR}/unielibc++/include
)

add_executable(panic usr.bin/panic.cpp)
add_executable(utop usr.bin/utop.c)

target_link_libraries(panic PRIVATE unielibcxx)
target_link_libraries(utop PRIVATE unielibc)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
