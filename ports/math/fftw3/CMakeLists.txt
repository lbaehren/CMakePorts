
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (FFTW3)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (FFTW3_VERSION        "3.2.2" )
set (FFTW3_SOURCE_ARCHIVE "fftw-${FFTW3_VERSION}.tar.gz" )
set (FFTW3_URL            "http://www.fftw.org/${FFTW3_SOURCE_ARCHIVE}" )
set (FFTW3_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================



## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_FFTW3_SOURCE ${FFTW3_SOURCE_ARCHIVE}
  PATHS ${FFTW3_SOURCE_DIR}
  )

if (NOT HAVE_FFTW3_SOURCE)
  set (HAVE_FFTW3_SOURCE ${FFTW3_URL})
endif (NOT HAVE_FFTW3_SOURCE)

## Build package from source

ExternalProject_Add (fftw3
  PREFIX ${FFTW3_BINARY_DIR}
  DOWNLOAD_DIR download
  SOURCE_DIR source
  URL ${HAVE_FFTW3_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${FFTW3_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
  )

