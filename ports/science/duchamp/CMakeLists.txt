
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (DUCHAMP)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (DUCHAMP_VERSION        "1.1.10" )
set (DUCHAMP_SOURCE_ARCHIVE "Duchamp-${DUCHAMP_VERSION}.tar.gz" )
set (DUCHAMP_URL            "http://www.atnf.csiro.au/people/Matthew.Whiting/Duchamp/downloads/${DUCHAMP_SOURCE_ARCHIVE}" )
set (DUCHAMP_MD5            "" )
set (DUCHAMP_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (DUCHAMP_FORCE_BUILD    "Force build and installation of package?" NO )
option (DUCHAMP_FROM_REPOS     "Install package from repository?"         NO )
option (DUCHAMP_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (DUCHAMP_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (DUCHAMP_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindCFITSIO)
include (FindWCSLIB)
#include (FindDUCHAMP)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (DUCHAMP_FROM_REPOS)
  set (DUCHAMP_FORCE_BUILD TRUE)
endif (DUCHAMP_FROM_REPOS)

if (NOT DUCHAMP_FOUND OR DUCHAMP_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (DUCHAMP_SOURCE ${DUCHAMP_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT DUCHAMP_SOURCE)
    set (DUCHAMP_SOURCE ${DUCHAMP_URL})
  endif (NOT DUCHAMP_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (duchamp
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${DUCHAMP_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-cfitsio=${CMAKE_INSTALL_PREFIX} --with-wcslib=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT DUCHAMP_FOUND OR DUCHAMP_FORCE_BUILD)
  
  add_custom_target (duchamp
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[DUCHAMP] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT DUCHAMP_FOUND OR DUCHAMP_FORCE_BUILD)
