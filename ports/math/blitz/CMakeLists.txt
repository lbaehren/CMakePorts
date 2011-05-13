
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Blitz)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (Blitz_VERSION        "0.9" )
set (Blitz_SOURCE_ARCHIVE "blitz-${Blitz_VERSION}.tar.gz" )
set (Blitz_URL            "http://downloads.sourceforge.net/project/blitz/blitz/Blitz%2B%2B%20${Blitz_VERSION}/${Blitz_SOURCE_ARCHIVE}" )
set (Blitz_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Blitz_FORCE_BUILD "Force build and installation of package?" ${FORCE_BUILD} )
option (Blitz_FROM_REPOS  "Install package from repository?"         NO )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindBlitz)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT BLITZ_FOUND OR Blitz_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (BLITZ_SOURCE ${Blitz_SOURCE_ARCHIVE}
    PATHS ${Blitz_SOURCE_DIR}
    )
  
  if (NOT BLITZ_SOURCE)
    set (BLITZ_SOURCE ${Blitz_URL})
  endif (NOT BLITZ_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (blitz
    PREFIX ${Blitz_BINARY_DIR}
    DOWNLOAD_DIR ${Blitz_BINARY_DIR}/download
    SOURCE_DIR ${Blitz_BINARY_DIR}/source
    URL ${BLITZ_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${Blitz_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
  
else (NOT BLITZ_FOUND OR Blitz_FORCE_BUILD)
  
  add_custom_target (blitz
    WORKING_DIRECTORY ${Blitz_BINARY_DIR}
    COMMENT "[Blitz] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT BLITZ_FOUND OR Blitz_FORCE_BUILD)
