
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SCRIBUS)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SCRIBUS_VERSION        "1.4.1" )
set (SCRIBUS_SOURCE_ARCHIVE "scribus-${SCRIBUS_VERSION}.tar.gz" )
set (SCRIBUS_URL            "http://downloads.sourceforge.net/project/scribus/scribus/${SCRIBUS_VERSION}/${SCRIBUS_SOURCE_ARCHIVE}" )
set (SCRIBUS_SVN            "svn://scribus.net/trunk/Scribus" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SCRIBUS_FORCE_BUILD    "Force build and installation of package?" NO )
option (SCRIBUS_FROM_REPOS     "Install package from repository?"         YES )
option (SCRIBUS_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SCRIBUS_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SCRIBUS_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindSCRIBUS)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SCRIBUS_FROM_REPOS)
  set (SCRIBUS_FORCE_BUILD TRUE)
endif (SCRIBUS_FROM_REPOS)

if (NOT SCRIBUS_FOUND OR SCRIBUS_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SCRIBUS_SOURCE ${SCRIBUS_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SCRIBUS_SOURCE)
    set (SCRIBUS_SOURCE ${SCRIBUS_URL})
  endif (NOT SCRIBUS_SOURCE)
  
  ## Build package from source
  
  if (SCRIBUS_FROM_REPOS)
    
    ExternalProject_Add (scribus
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SCRIBUS_SVN}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (SCRIBUS_FROM_REPOS)
    
    ExternalProject_Add (scribus
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SCRIBUS_SOURCE}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (SCRIBUS_FROM_REPOS)
  
else (NOT SCRIBUS_FOUND OR SCRIBUS_FORCE_BUILD)
  
  add_custom_target (scribus
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Scribus] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SCRIBUS_FOUND OR SCRIBUS_FORCE_BUILD)
