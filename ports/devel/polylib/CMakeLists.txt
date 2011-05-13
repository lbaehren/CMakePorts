
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PolyLib)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (PolyLib_VERSION        "5.22.5" )
set (PolyLib_SOURCE_ARCHIVE "polylib-${PolyLib_VERSION}.tar.gz" )
set (PolyLib_URL            "http://icps.u-strasbg.fr/PolyLib/polylib_src/${PolyLib_SOURCE_ARCHIVE}" )
set (PolyLib_MD5            "" )
set (PolyLib_GIT            "http://repo.or.cz/r/polylib.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PolyLib_FORCE_BUILD    "Force build and installation of package?" NO )
option (PolyLib_FROM_REPOS     "Install package from repository?"         NO )
option (PolyLib_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (PolyLib_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (PolyLib_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindPolyLib)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (PolyLib_FROM_REPOS)
  set (PolyLib_FORCE_BUILD TRUE)
endif (PolyLib_FROM_REPOS)

if (NOT PolyLib_FOUND OR PolyLib_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (PolyLib_SOURCE ${PolyLib_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT PolyLib_SOURCE)
    set (PolyLib_SOURCE ${PolyLib_URL})
  endif (NOT PolyLib_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (polylib
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${PolyLib_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT PolyLib_FOUND OR PolyLib_FORCE_BUILD)
  
  add_custom_target (polylib
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[PolyLib] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT PolyLib_FOUND OR PolyLib_FORCE_BUILD)
