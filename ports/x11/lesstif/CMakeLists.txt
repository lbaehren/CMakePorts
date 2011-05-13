
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LessTif)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (LessTif_VERSION        "0.95.2" )
set (LessTif_SOURCE_ARCHIVE "lesstif-${LessTif_VERSION}.tar.gz" )
set (LessTif_URL            "http://downloads.sourceforge.net/project/lesstif/lesstif/${LessTif_VERSION}/${LessTif_SOURCE_ARCHIVE}" )
set (LessTif_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LessTif_FORCE_BUILD    "Force build and installation of package?" NO )
option (LessTif_FROM_REPOS     "Install package from repository?"         NO )
option (LessTif_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LessTif_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LessTif_ENABLE_TESTING)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_LessTif_SOURCE ${LessTif_SOURCE_ARCHIVE}
  PATHS ${LessTif_SOURCE_DIR}
  )

if (NOT HAVE_LessTif_SOURCE)
  set (HAVE_LessTif_SOURCE ${LessTif_URL})
endif (NOT HAVE_LessTif_SOURCE)

## Build package from source

ExternalProject_Add (lesstif
  PREFIX ${LessTif_BINARY_DIR}
  DOWNLOAD_DIR ${LessTif_BINARY_DIR}/download
  SOURCE_DIR ${LessTif_BINARY_DIR}/source
  URL ${HAVE_LessTif_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${LessTif_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND sudo make install
  )
