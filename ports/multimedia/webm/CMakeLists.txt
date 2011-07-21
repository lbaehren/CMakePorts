
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (WebM)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (WebM_VERSION        "" )
set (WebM_SOURCE_ARCHIVE "" )
set (WebM_URL            "" )
set (WebM_MD5            "" )
set (WebM_GIT            "git://review.webmproject.org/libwebm.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (WebM_FORCE_BUILD    "Force build and installation of package?" NO )
option (WebM_FROM_REPOS     "Install package from repository?"         NO )
option (WebM_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (WebM_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (WebM_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindWebM)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (WebM_FROM_REPOS)
  set (WebM_FORCE_BUILD TRUE)
endif (WebM_FROM_REPOS)

if (NOT WebM_FOUND OR WebM_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (WebM_SOURCE ${WebM_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT WebM_SOURCE)
    set (WebM_SOURCE ${WebM_URL})
  endif (NOT WebM_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (webm
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    GIT_REPOSITORY ${WebM_GIT}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT WebM_FOUND OR WebM_FORCE_BUILD)
  
  add_custom_target (webm
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[WebM] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT WebM_FOUND OR WebM_FORCE_BUILD)
