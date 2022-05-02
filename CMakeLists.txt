cmake_minimum_required(VERSION 3.22)
project(merlin CXX)

set(CMAKE_CXX_STANDARD 20)
set(TARGET_PLATFORM x86_64)

file(GLOB CXXSources kernel/stivale2.h kernel/*.cpp kernel/abi/${TARGET_PLATFORM}/*.cpp)

add_executable(merlin ${CXXSources})

target_include_directories(merlin PRIVATE vendor/limine)
set_target_properties(merlin PROPERTIES SUFFIX ".sys")
set_target_properties(merlin PROPERTIES LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/ld/${TARGET_PLATFORM}/kernel.ld")
target_compile_options( merlin PUBLIC
        -ffreestanding
        -fno-stack-protector
        -fno-stack-check
        -funsigned-char
        -fno-pic
        -mabi=sysv
        -mno-mmx
        -mno-3dnow
        -mno-sse
        -mno-sse2
        -mno-red-zone
        -mcmodel=kernel
        -O2
        -g
        -Wall
        -Wextra
        -Wpedantic
        -pipe
)
target_link_options(merlin PUBLIC
        -T ${CMAKE_CURRENT_SOURCE_DIR}/ld/x86_64/kernel.ld
        -fuse-ld=lld
        -nostdlib
        -static
)
