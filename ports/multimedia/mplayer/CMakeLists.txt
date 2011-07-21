
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (MPlayer)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================

set (MPlayer_VERSION        "" )
set (MPlayer_SOURCE_ARCHIVE "mplayer.tgz" )
set (MPlayer_URL            "mplayer.tgz" )
set (MPlayer_SVN            "svn://svn.mplayerhq.hu/mplayer/trunk" )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindYasm)

if (YASM_EXECUTABLE)
  set (enable_yasm "--yasm=${YASM_EXECUTABLE}")
else (YASM_EXECUTABLE)
  message (STATUS "[MPlayer] Unable to find Yasm!")
  set (enable_yasm "--yasm\"\"")
endif (YASM_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_MPlayer_SOURCE ${MPlayer_SOURCE_ARCHIVE}
  PATHS ${MPlayer_SOURCE_DIR}
  )

## Build package from source

if (HAVE_MPlayer_SOURCE)
  ## Build from local source archive
  ExternalProject_Add (mplayer
    PREFIX ${MPlayer_BINARY_DIR}
    DOWNLOAD_DIR ${MPlayer_BINARY_DIR}/download
    SOURCE_DIR ${MPlayer_BINARY_DIR}/source
    URL ${HAVE_MPlayer_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${MPlayer_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
else (HAVE_MPlayer_SOURCE)
  ## Build from repository checkout
  ExternalProject_Add (mplayer
    PREFIX ${MPlayer_BINARY_DIR}
    DOWNLOAD_DIR ${MPlayer_BINARY_DIR}/download
    SOURCE_DIR ${MPlayer_BINARY_DIR}/source
    SVN_REPOSITORY ${MPlayer_SVN}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${MPlayer_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
endif (HAVE_MPlayer_SOURCE)
