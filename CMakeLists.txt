cmake_minimum_required(VERSION 3.5)
project(test_egl_gbm VERSION 0.1 LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

set(CMAKE_CXX_STANDARD 11)

find_package(Libdrm)
find_package(LibEGL)
find_package(gbm)

# Try to use standard official FindOpenGL.cmake
# set(OPENGL_USE_EGL ON)
# find_package(OpenGL)
# ^^ does not work or dunno how to use.
# CMake Error at CMakeLists.txt:15 (add_executable):
#     Target "test_egl_gbm" links to target "OpenGL::EGL" but the target was not found.

add_executable(${PROJECT_NAME} "main.cpp")

target_link_libraries(${PROJECT_NAME}
    Libdrm::Libdrm
    LibEGL::LibEGL
    gbm::gbm
)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
