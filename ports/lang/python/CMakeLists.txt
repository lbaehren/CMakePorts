
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Python)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (Python_VERSION        "2.7.1" )
set (Python_SOURCE_ARCHIVE "Python-${Python_VERSION}.tgz" )
set (Python_URL            "http://www.python.org/ftp/python/${Python_VERSION}/${Python_SOURCE_ARCHIVE}" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Python_FORCE_BUILD    "Force build and installation of package?" NO )
option (Python_FROM_REPOS     "Install package from repository?"         NO )
option (Python_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Python_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Python_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindPythonInterp)
include (FindPythonLibs)
include (FindReadline)
include (FindZLIB)

# - readline
# - ncurses
# - gdbm
# - gettext

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

##____________________________________________________________________
## Locate source file to build from

find_file (HAVE_Python_SOURCE ${Python_SOURCE_ARCHIVE}
  PATHS ${Python_SOURCE_DIR}
  )

if (NOT HAVE_Python_SOURCE)
  set (HAVE_Python_SOURCE ${Python_URL})
endif (NOT HAVE_Python_SOURCE)

##____________________________________________________________________
## Build package from source

if (APPLE)
  ## Build as Framework when on Mac OS X
  ExternalProject_Add (python
    PREFIX ${Python_BINARY_DIR}
    DOWNLOAD_DIR ${Python_BINARY_DIR}/download
    SOURCE_DIR ${Python_BINARY_DIR}/source
    URL ${HAVE_Python_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${Python_BINARY_DIR}/source/configure --enable-framework=${CMAKE_INSTALL_PREFIX}/Library/Frameworks
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
else (APPLE)
  ExternalProject_Add (python
    PREFIX ${Python_BINARY_DIR}
    DOWNLOAD_DIR ${Python_BINARY_DIR}/download
    SOURCE_DIR ${Python_BINARY_DIR}/source
    URL ${HAVE_Python_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${Python_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
endif (APPLE)
