
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Doxygen)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================

set (Doxygen_VERSION        "" )
set (Doxygen_SOURCE_ARCHIVE "" )
set (Doxygen_URL            "" )
set (Doxygen_SVN            "https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk" )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_Doxygen_SOURCE ${Doxygen_SOURCE_ARCHIVE}
  PATHS ${Doxygen_SOURCE_DIR}
  )

if (NOT HAVE_Doxygen_SOURCE)
  set (HAVE_Doxygen_SOURCE ${Doxygen_URL})
endif (NOT HAVE_Doxygen_SOURCE)

## Build package from source

ExternalProject_Add (doxygen
  PREFIX ${Doxygen_BINARY_DIR}
  DOWNLOAD_DIR ${Doxygen_BINARY_DIR}/download
  SOURCE_DIR ${Doxygen_BINARY_DIR}/source
  SVN_REPOSITORY ${Doxygen_SVN}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${Doxygen_BINARY_DIR}/source/configure --prefix ${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
  )
