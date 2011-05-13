
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (XZ)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================



## ==============================================================================
##
##  Package information
##
## ==============================================================================

set (XZ_VERSION        "4.999" )
set (XZ_SOURCE_ARCHIVE "xz-${XZ_VERSION}.9beta.tar.gz" )
set (XZ_URL            "" )
set (XZ_SVN            "" )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_XZ_SOURCE ${XZ_SOURCE_ARCHIVE}
  PATHS ${XZ_SOURCE_DIR}
  )

if (NOT HAVE_XZ_SOURCE)
  set (HAVE_XZ_SOURCE ${XZ_URL})
endif (NOT HAVE_XZ_SOURCE)

## Build package from source

ExternalProject_Add (xz
  PREFIX ${XZ_BINARY_DIR}
  DOWNLOAD_DIR ${XZ_BINARY_DIR}/download
  SOURCE_DIR ${XZ_BINARY_DIR}/source
  URL ${HAVE_XZ_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${XZ_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND sudo make install
  )
