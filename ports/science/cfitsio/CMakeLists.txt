
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CFITSIO)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (CFITSIO_VERSION        "3280" )
set (CFITSIO_SOURCE_ARCHIVE "cfitsio${CFITSIO_VERSION}.tar.gz" )
set (CFITSIO_URL            "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${CFITSIO_SOURCE_ARCHIVE}" )
set (CFITSIO_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CFITSIO_FORCE_BUILD "Force build and installation of package?" ${FORCE_BUILD} )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindCFITSIO)

## ==============================================================================
##
##  Build instructions
##
##  - Compile CFITSIO as a Universal Binary on Mac OS-X
##    - setenv CFLAGS "-arch ppc -arch i386 -g -O2"
##    - export CFLAGS="-arch ppc -arch i386 -g -O2"
##
## ==============================================================================

if (NOT CFITSIO_FOUND OR CFITSIO_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (HAVE_CFITSIO_SOURCE ${CFITSIO_SOURCE_ARCHIVE}
    PATHS ${CFITSIO_SOURCE_DIR}
    )
  
  if (NOT HAVE_CFITSIO_SOURCE)
    set (HAVE_CFITSIO_SOURCE ${CFITSIO_URL})
  endif (NOT HAVE_CFITSIO_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (cfitsio
    PREFIX ${CFITSIO_BINARY_DIR}
    DOWNLOAD_DIR ${CFITSIO_BINARY_DIR}/download
    SOURCE_DIR ${CFITSIO_BINARY_DIR}/source
    URL ${HAVE_CFITSIO_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${CFITSIO_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}  --enable-lfs
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT CFITSIO_FOUND OR CFITSIO_FORCE_BUILD)
  
  add_custom_target (cfitsio
    WORKING_DIRECTORY ${CFITSIO_BINARY_DIR}
    COMMENT "[CFITSIO] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CFITSIO_FOUND OR CFITSIO_FORCE_BUILD)
