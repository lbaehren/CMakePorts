
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (YAMKA)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (YAMKA_VERSION        "" )
set (YAMKA_SOURCE_ARCHIVE "" )
set (YAMKA_URL            "" )
set (YAMKA_SVN            "https://yamka.svn.sourceforge.net/svnroot/yamka/trunk/yamka" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (YAMKA_FORCE_BUILD    "Force build and installation of package?" NO  )
option (YAMKA_FROM_REPOS     "Install package from repository?"         YES )
option (YAMKA_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (YAMKA_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (YAMKA_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindYAMKA)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (YAMKA_FROM_REPOS)
  set (YAMKA_FORCE_BUILD TRUE)
endif (YAMKA_FROM_REPOS)

if (NOT YAMKA_FOUND OR YAMKA_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (YAMKA_SOURCE ${YAMKA_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT YAMKA_SOURCE)
    set (YAMKA_SOURCE ${YAMKA_URL})
  endif (NOT YAMKA_SOURCE)
  
  ## Build package from source
  
  if (YAMKA_FROM_REPOS)
    
    ExternalProject_Add (yamka
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${YAMKA_SVN}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (YAMKA_FROM_REPOS)
    
    ExternalProject_Add (yamka
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${YAMKA_SOURCE}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (YAMKA_FROM_REPOS)
  
else (NOT YAMKA_FOUND OR YAMKA_FORCE_BUILD)
  
  add_custom_target (yamka
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[yamka] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT YAMKA_FOUND OR YAMKA_FORCE_BUILD)
