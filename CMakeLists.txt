cmake_minimum_required(VERSION 3.5)
project(test_egl_gbm VERSION 0.1 LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

set(CMAKE_CXX_STANDARD 11)

find_package(Libdrm)
find_package(LibEGL)
find_package(gbm)

add_executable(${PROJECT_NAME} "main.cpp")

target_link_libraries(${PROJECT_NAME}
    Libdrm::Libdrm
    LibEGL::LibEGL
    gbm::gbm
)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
