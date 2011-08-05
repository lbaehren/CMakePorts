
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (DAL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (DAL_VERSION        "" )
set (DAL_SOURCE_ARCHIVE "" )
set (DAL_URL            "" )
set (DAL_GIT            "https://github.com/nextgen-astrodata/DAL.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (DAL_FORCE_BUILD    "Force build and installation of package?" NO )
option (DAL_FROM_REPOS     "Install package from repository?"         YES )
option (DAL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (DAL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (DAL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindDAL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (DAL_FROM_REPOS)
  set (DAL_FORCE_BUILD TRUE)
endif (DAL_FROM_REPOS)

if (NOT DAL_FOUND OR DAL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (DAL_SOURCE ${DAL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT DAL_SOURCE)
    set (DAL_SOURCE ${DAL_URL})
  endif (NOT DAL_SOURCE)
  
  ## Build package from source
  
  if (DAL_FROM_REPOS)
    
    ExternalProject_Add (dal
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${DAL_GIT}
      CMAKE_ARGS -DDAL_ENABLE_TESTING=FALSE -DDAL_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (DAL_FROM_REPOS)
    
    ExternalProject_Add (dal
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${DAL_SOURCE}
      CMAKE_ARGS -DDAL_ENABLE_TESTING=FALSE -DDAL_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (DAL_FROM_REPOS)
  
else (NOT DAL_FOUND OR DAL_FORCE_BUILD)
  
  add_custom_target (dal
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[DAL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT DAL_FOUND OR DAL_FORCE_BUILD)
