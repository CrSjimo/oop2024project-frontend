cmake_minimum_required(VERSION 3.17)

project(oop2024project-frontend VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 COMPONENTS Quick Gui REQUIRED)

qt_standard_project_setup(REQUIRES 6.8)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(src)