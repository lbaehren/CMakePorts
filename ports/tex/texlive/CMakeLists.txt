
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TeXLive)

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

set (TeXLive_VERSION        "" )
set (TeXLive_SOURCE_ARCHIVE "install-tl-unx.tar.gz" )
set (TeXLive_URL            "http://mirror.ctan.org/systems/texlive/tlnet/${TeXLive_SOURCE_ARCHIVE}" )

## ==============================================================================
##
##  Build instructions
#
#  cd /your/download/directory
#  ./install-tl
#  [... messages omitted ...]
#  Enter command: i
#  [... when done, see below for post-install ...]
#
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_TeXLive_SOURCE ${TeXLive_SOURCE_ARCHIVE}
  PATHS ${TeXLive_SOURCE_DIR}
  )

if (NOT HAVE_TeXLive_SOURCE)
  set (HAVE_TeXLive_SOURCE ${TeXLive_URL})
endif (NOT HAVE_TeXLive_SOURCE)

## Define TeXLive installation prefix and export the location as environment
## variable

set (TEXLIVE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share/texlive")
set ( ENV{TEXLIVE_INSTALL_PREFIX} ${TEXLIVE_INSTALL_PREFIX} )

## Build package from source

ExternalProject_Add (texlive
  PREFIX ${PROJECT_BINARY_DIR}
  DOWNLOAD_DIR download
  SOURCE_DIR source
  URL ${HAVE_TeXLive_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${PORT_INSTALL_COMMAND} mkdir -p ${TEXLIVE_INSTALL_PREFIX}
  BUILD_COMMAND ${PORT_INSTALL_COMMAND} chmod a+rw ${TEXLIVE_INSTALL_PREFIX}
  INSTALL_COMMAND export TEXLIVE_INSTALL_PREFIX=${TEXLIVE_INSTALL_PREFIX} && ${PROJECT_BINARY_DIR}/source/install-tl
  )
