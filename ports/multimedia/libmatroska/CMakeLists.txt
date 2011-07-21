
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBMATROSKA)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBMATROSKA_VERSION        "1.1.0" )
set (LIBMATROSKA_SOURCE_ARCHIVE "libmatroska-${LIBMATROSKA_VERSION}.tar.bz2" )
set (LIBMATROSKA_URL            "http://dl.matroska.org/downloads/libmatroska/${LIBMATROSKA_SOURCE_ARCHIVE}" )
set (LIBMATROSKA_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBMATROSKA_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBMATROSKA_FROM_REPOS     "Install package from repository?"         NO )
option (LIBMATROSKA_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBMATROSKA_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBMATROSKA_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLIBMATROSKA)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBMATROSKA_FROM_REPOS)
  set (LIBMATROSKA_FORCE_BUILD TRUE)
endif (LIBMATROSKA_FROM_REPOS)

if (NOT LIBMATROSKA_FOUND OR LIBMATROSKA_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBMATROSKA_SOURCE ${LIBMATROSKA_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBMATROSKA_SOURCE)
    set (LIBMATROSKA_SOURCE ${LIBMATROSKA_URL})
  endif (NOT LIBMATROSKA_SOURCE)
  
  ## Build package from source
  
  if (LIBMATROSKA_FROM_REPOS)
    
    ExternalProject_Add (libmatroska
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBMATROSKA_SVN}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/libmatroska.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBMATROSKA_FROM_REPOS)
    
    ExternalProject_Add (libmatroska
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBMATROSKA_SOURCE}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/libmatroska.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBMATROSKA_FROM_REPOS)
  
else (NOT LIBMATROSKA_FOUND OR LIBMATROSKA_FORCE_BUILD)
  
  add_custom_target (libmatroska
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[LIBMATROSKA] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBMATROSKA_FOUND OR LIBMATROSKA_FORCE_BUILD)
