#.rst:
# FindEGL
# -------
#
# Try to find libEGL on a Unix system.
#
# This will define the following variables:
#
# ``LibEGL_FOUND``
#     True if (the requested version of) libEGL is available
# ``LibEGL_VERSION``
#     The version of libEGL
# ``LibEGL_LIBRARIES``
#     This can be passed to target_link_libraries() instead of the ``LibEGL::LibEGL``
#     target
# ``LibEGL_INCLUDE_DIRS``
#     This should be passed to target_include_directories() if the target is not
#     used for linking
# ``LibEGL_DEFINITIONS``
#     This should be passed to target_compile_options() if the target is not
#     used for linking
#
# If ``LibEGL_FOUND`` is TRUE, it will also define the following imported target:
#
# ``LibEGL::LibEGL``
#     The libEGL library
#
# In general we recommend using the imported target, as it is easier to use.
# Bear in mind, however, that if the target is in the link interface of an
# exported library, it must be made available by the package config file.
#=============================================================================

if(CMAKE_VERSION VERSION_LESS 2.8.12)
    message(FATAL_ERROR "CMake 2.8.12 is required by FindEGL.cmake")
endif()
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    message(AUTHOR_WARNING "Your project should require at least CMake 2.8.12 to use FindEGL.cmake")
endif()

if(NOT WIN32)
    # Use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    pkg_check_modules(PKG_LibEGL QUIET egl)

    set(LibEGL_DEFINITIONS ${PKG_LibEGL_CFLAGS_OTHER})
    set(LibEGL_VERSION ${PKG_LibEGL_VERSION})

    find_path(LibEGL_INCLUDE_DIR
        NAMES
            EGL/egl.h EGL/eglext.h
        HINTS
            ${PKG_LibEGL_INCLUDE_DIRS} "/usr/include" "/usr/local/include"
    )
    find_library(LibEGL_LIBRARY
        NAMES
            EGL
        HINTS
            ${PKG_LibEGL_LIBRARY_DIRS}
    )

    message(STATUS LibEGL_INCLUDE_DIR " - " ${LibEGL_INCLUDE_DIR})
    message(STATUS LibEGL_LIBRARY " - " ${LibEGL_LIBRARY})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(LibEGL
        FOUND_VAR
            LibEGL_FOUND
        REQUIRED_VARS
            LibEGL_LIBRARY
            LibEGL_INCLUDE_DIR
        VERSION_VAR
            LibEGL_VERSION
    )

    if(LibEGL_FOUND AND NOT TARGET LibEGL::LibEGL)
        add_library(LibEGL::LibEGL UNKNOWN IMPORTED)
        set_target_properties(LibEGL::LibEGL PROPERTIES
            IMPORTED_LOCATION "${LibEGL_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${LibEGL_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${LibEGL_INCLUDE_DIR}"
            INTERFACE_INCLUDE_DIRECTORIES "${LibEGL_INCLUDE_DIR}/EGL"
        )
    endif()

    mark_as_advanced(LibEGL_LIBRARY LibEGL_INCLUDE_DIR)

    # compatibility variables
    set(LibEGL_LIBRARIES ${LibEGL_LIBRARY})
    set(LibEGL_INCLUDE_DIRS ${LibEGL_INCLUDE_DIR})
    set(LibEGL_VERSION_STRING ${LibEGL_VERSION})

else()
    message(STATUS "FindEGL.cmake cannot find libEGL on Windows systems.")
    set(LibEGL_FOUND FALSE)
endif()

include(FeatureSummary)
set_package_properties(LibEGL PROPERTIES
    URL "https://www.mesa3d.org/egl.html"
    DESCRIPTION "The Mesa 3D Graphics Library"
)
