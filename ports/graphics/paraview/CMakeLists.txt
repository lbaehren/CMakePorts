
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (ParaView)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (ParaView_VERSION        "" )
set (ParaView_SOURCE_ARCHIVE "" )
set (ParaView_URL            "" )
set (ParaView_MD5            "" )
set (ParaView_GIT            "git://paraview.org/ParaView.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ParaView_FORCE_BUILD    "Force build and installation of package?" NO )
option (ParaView_FROM_REPOS     "Install package from repository?"         NO )
option (ParaView_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (ParaView_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (ParaView_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindParaView)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (ParaView_FROM_REPOS)
  set (ParaView_FORCE_BUILD TRUE)
endif (ParaView_FROM_REPOS)

if (NOT ParaView_FOUND OR ParaView_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (ParaView_SOURCE ${ParaView_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT ParaView_SOURCE)
    set (ParaView_SOURCE ${ParaView_URL})
  endif (NOT ParaView_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (paraview
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    GIT_REPOSITORY ${ParaView_GIT}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT ParaView_FOUND OR ParaView_FORCE_BUILD)
  
  add_custom_target (paraview
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[ParaView] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT ParaView_FOUND OR ParaView_FORCE_BUILD)
