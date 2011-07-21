
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (ROOT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================

set (ROOT_VERSION        "5.27" )
set (ROOT_SOURCE_ARCHIVE "root-${ROOT_VERSION}.tgz" )
set (ROOT_REPOSITORY     "http://root.cern.ch/svn/root/trunk" )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (UNIX)
  if (APPLE)
    set (root_arch "macosx")
  else (APPLE)
    set (root_arch "linux")
  endif (APPLE)
else (UNIX)
  if (WIN32)
    set (root_arch "win32gcc")
  endif (WIN32)
endif (UNIX)

## Locate source file to build from

find_file (HAVE_ROOT_SOURCE ${ROOT_SOURCE_ARCHIVE}
  PATHS ${ROOT_SOURCE_DIR}
  )

## Build package from source

if (HAVE_ROOT_SOURCE)
  ExternalProject_Add (root
    PREFIX ${ROOT_BINARY_DIR}
    DOWNLOAD_DIR ${ROOT_BINARY_DIR}/download
    SOURCE_DIR ${ROOT_BINARY_DIR}/source
    URL ${HAVE_ROOT_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${ROOT_BINARY_DIR}/source/configure ${root_arch} --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
else (HAVE_ROOT_SOURCE)
  ExternalProject_Add (root
    PREFIX ${ROOT_BINARY_DIR}
    DOWNLOAD_DIR ${ROOT_BINARY_DIR}/download
    SOURCE_DIR ${ROOT_BINARY_DIR}/source
    SVN_REPOSITORY ${ROOT_REPOSITORY}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${ROOT_BINARY_DIR}/source/configure ${root_arch} --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
endif (HAVE_ROOT_SOURCE)
