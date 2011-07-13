
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CMake)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Package information
##
## ==============================================================================

set (CMAKE_VERSION_MAJOR  "2" )
set (CMAKE_VERSION_MINOR  "8" )
set (CMAKE_VERSION        "${CMAKE_VERSION_MAJOR}.${CMAKE_VERSION_MINOR}.3" )
set (CMAKE_SOURCE_ARCHIVE "cmake-${CMAKE_VERSION}.tar.gz" )
set (CMAKE_URL            "http://www.cmake.org/files/v${CMAKE_VERSION_MAJOR}.${CMAKE_VERSION_MINOR}/${CMAKE_SOURCE_ARCHIVE}" )
set (CMAKE_SVN            ":pserver:anonymous@cmake.org:/cmake.git" )
set (CMAKE_GIT            "git://cmake.org/cmake.git")

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CMake_FORCE_BUILD    "Force build and installation of package?" NO  )
option (CMake_FROM_REPOS     "Install package from repository?"         YES )
option (CMake_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CMake_ENABLE_TESTING)
  ## CMake settings
  include (CTest)
  enable_testing()
  ## build command 
  set (BUILD_COMMAND "make Experimental")
else (CMake_ENABLE_TESTING)
  set (BUILD_COMMAND "make")
endif (CMake_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGit)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GIT_FOUND)
  ExternalProject_Add (cmake
    PREFIX ${CMake_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    GIT_REPOSITORY ${CMAKE_GIT}
    CONFIGURE_COMMAND ${CMake_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
else (GIT_FOUND)
  add_custom_target (cmake
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[cmake] Missing installation of Git - unable to get source code!"
    )
endif (GIT_FOUND)

