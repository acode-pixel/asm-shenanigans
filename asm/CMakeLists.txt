cmake_minimum_required(VERSION 3.23.4)
project(asm-shenanigans ASM_NASM C)

add_executable(boot boot.asm)
target_compile_options(boot PUBLIC "-fbin")
target_include_directories(boot PUBLIC "../asm")
