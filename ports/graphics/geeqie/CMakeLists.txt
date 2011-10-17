
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GEEQIE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GEEQIE_VERSION        "" )
set (GEEQIE_SOURCE_ARCHIVE "" )
set (GEEQIE_URL            "" )
set (GEEQIE_SVN            "https://geeqie.svn.sourceforge.net/svnroot/geeqie/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GEEQIE_FORCE_BUILD    "Force build and installation of package?" NO )
option (GEEQIE_FROM_REPOS     "Install package from repository?"         YES )
option (GEEQIE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GEEQIE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GEEQIE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindGEEQIE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GEEQIE_FROM_REPOS)
  set (GEEQIE_FORCE_BUILD TRUE)
endif (GEEQIE_FROM_REPOS)

if (NOT GEEQIE_FOUND OR GEEQIE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GEEQIE_SOURCE ${GEEQIE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GEEQIE_SOURCE)
    set (GEEQIE_SOURCE ${GEEQIE_URL})
  endif (NOT GEEQIE_SOURCE)
  
  ## Build package from source
  
  if (GEEQIE_FROM_REPOS)
    
    ExternalProject_Add (geeqie
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${GEEQIE_SVN}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (GEEQIE_FROM_REPOS)
    
    ExternalProject_Add (geeqie
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GEEQIE_SOURCE}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (GEEQIE_FROM_REPOS)
  
else (NOT GEEQIE_FOUND OR GEEQIE_FORCE_BUILD)
  
  add_custom_target (geeqie
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[geeqie] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GEEQIE_FOUND OR GEEQIE_FORCE_BUILD)
