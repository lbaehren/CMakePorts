
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PIL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package description
set (PIL_VERSION        "" )
set (PIL_SOURCE_ARCHIVE "pil.tgz" )
set (PIL_URL            "" )
set (PIL_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PIL_FORCE_BUILD "Force build and installation of package?" NO )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_path (PIL_INCLUDES pil.h
  PATHS /sw /usr /usr/local
  PATH_SUFFIXES include pil include/pil
  )

find_library (PIL_PIL_LIBRARY pil
  PATHS /sw /usr /usr/local
  PATH_SUFFIXES lib
  )

if (PIL_INCLUDES AND PIL_PIL_LIBRARY)
  set (HAVE_PIL TRUE)
endif (PIL_INCLUDES AND PIL_PIL_LIBRARY)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT HAVE_PIL OR PIL_FORCE_BUILD)

## Locate source file to build from

find_file (HAVE_PIL_SOURCE ${PIL_SOURCE_ARCHIVE}
  PATHS ${PIL_SOURCE_DIR}
  )

if (NOT HAVE_PIL_SOURCE)
  set (HAVE_PIL_SOURCE ${PIL_URL})
endif (NOT HAVE_PIL_SOURCE)

## Build package from source

ExternalProject_Add (pil
  PREFIX ${PIL_BINARY_DIR}
  DOWNLOAD_DIR ${PIL_BINARY_DIR}/download
  SOURCE_DIR ${PIL_BINARY_DIR}/source
  URL ${HAVE_PIL_SOURCE}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
  )

## Pre-configure of configuration scripts
ExternalProject_Add_Step (pil pil_preconfig
  COMMAND cp ${PIL_SOURCE_DIR}/pil.cmake CMakeLists.txt
  COMMENT "Replacing original CMakeLists.txt"
  DEPENDEES patch
  DEPENDERS configure
  WORKING_DIRECTORY ${PIL_BINARY_DIR}/source
  )

  
else (NOT HAVE_PIL OR PIL_FORCE_BUILD)
  
  add_custom_target (pil
    WORKING_DIRECTORY ${PIL_BINARY_DIR}
    COMMENT "[PIL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_PIL OR PIL_FORCE_BUILD)
