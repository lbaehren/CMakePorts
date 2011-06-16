
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PLPLOT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (PLPLOT_VERSION        "5.9.7" )
set (PLPLOT_SOURCE_ARCHIVE "plplot-${PLPLOT_VERSION}.tar.gz" )
set (PLPLOT_URL            "http://downloads.sourceforge.net/project/plplot/plplot/${PLPLOT_VERSION}%20Source/${PLPLOT_SOURCE_ARCHIVE}" )
set (PLPLOT_MD5            "" )
set (PLPLOT_SVN            "https://plplot.svn.sourceforge.net/svnroot/plplot/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PLPLOT_FORCE_BUILD    "Force build and installation of package?" NO )
option (PLPLOT_FROM_REPOS     "Install package from repository?"         NO )
option (PLPLOT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (PLPLOT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (PLPLOT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindPLPLOT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (PLPLOT_FROM_REPOS)
  set (PLPLOT_FORCE_BUILD TRUE)
endif (PLPLOT_FROM_REPOS)

if (NOT PLPLOT_FOUND OR PLPLOT_FORCE_BUILD)
  
  configure_file (
    ${PROJECT_SOURCE_DIR}/plplot.cmake.in
    ${PROJECT_BINARY_DIR}/plplot.cmake
    )

  ## Locate source file to build from
  
  find_file (PLPLOT_SOURCE ${PLPLOT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT PLPLOT_SOURCE)
    set (PLPLOT_SOURCE ${PLPLOT_URL})
  endif (NOT PLPLOT_SOURCE)
  
  ## Build package from source
  
  if (PLPLOT_FROM_REPOS)
    
  ExternalProject_Add (plplot
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    SVN_REPOSITORY ${PLPLOT_SVN}
    CMAKE_ARGS -C ${PLPLOT_BINARY_DIR}/plplot.cmake -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )

  else (PLPLOT_FROM_REPOS)
    
  ExternalProject_Add (plplot
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${PLPLOT_SOURCE}
    CMAKE_ARGS -C ${PLPLOT_BINARY_DIR}/plplot.cmake -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
  endif (PLPLOT_FROM_REPOS)
  
else (NOT PLPLOT_FOUND OR PLPLOT_FORCE_BUILD)
  
  add_custom_target (plplot
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[PLplot] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT PLPLOT_FOUND OR PLPLOT_FORCE_BUILD)
