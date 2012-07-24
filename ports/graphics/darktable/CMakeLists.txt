
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (DARKTABLE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (DARKTABLE_SERIES        "1.0" )
set (DARKTABLE_VERSION        "${DARKTABLE_SERIES}.5" )
set (DARKTABLE_SOURCE_ARCHIVE "darktable-${DARKTABLE_VERSION}.tar.gz" )
set (DARKTABLE_URL            "http://downloads.sourceforge.net/project/darktable/darktable/${DARKTABLE_SERIES}/${DARKTABLE_SOURCE_ARCHIVE}" )
set (DARKTABLE_GIT            "git://github.com/darktable-org/darktable.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (DARKTABLE_FORCE_BUILD    "Force build and installation of package?" NO )
option (DARKTABLE_FROM_REPOS     "Install package from repository?"         NO )
option (DARKTABLE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (DARKTABLE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (DARKTABLE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindDARKTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (DARKTABLE_FROM_REPOS)
  set (DARKTABLE_FORCE_BUILD TRUE)
endif (DARKTABLE_FROM_REPOS)

if (NOT DARKTABLE_FOUND OR DARKTABLE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (DARKTABLE_SOURCE ${DARKTABLE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT DARKTABLE_SOURCE)
    set (DARKTABLE_SOURCE ${DARKTABLE_URL})
  endif (NOT DARKTABLE_SOURCE)
  
  ## Build package from source
  
  if (DARKTABLE_FROM_REPOS)
    
    ExternalProject_Add (darktable
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${DARKTABLE_GIT}
      CMAKE_ARGS  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (DARKTABLE_FROM_REPOS)
    
    ExternalProject_Add (darktable
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${DARKTABLE_SOURCE}
      CMAKE_ARGS  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (DARKTABLE_FROM_REPOS)
  
else (NOT DARKTABLE_FOUND OR DARKTABLE_FORCE_BUILD)
  
  add_custom_target (darktable
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[darktable] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT DARKTABLE_FOUND OR DARKTABLE_FORCE_BUILD)
