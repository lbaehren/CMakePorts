
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LAPACK)

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

set (LAPACK_VERSION        "3.3.0" )
set (LAPACK_SOURCE_ARCHIVE "lapack-${LAPACK_VERSION}.tgz" )
set (LAPACK_URL            "http://www.netlib.org/lapack/${LAPACK_SOURCE_ARCHIVE}" )
set (LAPACK_SVN            "http://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk" )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_LAPACK_SOURCE ${LAPACK_SOURCE_ARCHIVE}
  PATHS ${LAPACK_SOURCE_DIR}
  )

if (NOT HAVE_LAPACK_SOURCE)
  set (HAVE_LAPACK_SOURCE ${LAPACK_URL})
endif (NOT HAVE_LAPACK_SOURCE)

## Build package from source

ExternalProject_Add (lapack
  PREFIX ${PROJECT_BINARY_DIR}
  DOWNLOAD_DIR download
  SOURCE_DIR source
  URL ${HAVE_LAPACK_SOURCE}
  CMAKE_ARGS -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND sudo make install
  )
