cmake_minimum_required(VERSION 2.6)
project(sample)

include_directories($ENV{HOME}/local/include)
link_directories($ENV{HOME}/local/lib)

include(compiler_settings.cmake)

enable_testing()
set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_parent_directories()

cxx_static_library(hello "" hello.cpp)
cxx_test(hello_test "hello" hello_test.cpp)

cxx_executable(hello_world "hello" hello_world.cpp print_driver_impl.cpp)
