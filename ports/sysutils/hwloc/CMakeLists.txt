
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (HWLOC)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (HWLOC_VERSION        "" )
set (HWLOC_SOURCE_ARCHIVE "" )
set (HWLOC_URL            "" )
set (HWLOC_SVN            "http://svn.open-mpi.org/svn/hwloc/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (HWLOC_FORCE_BUILD    "Force build and installation of package?" NO  )
option (HWLOC_FROM_REPOS     "Install package from repository?"         YES )
option (HWLOC_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (HWLOC_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (HWLOC_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindHWLOC)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (HWLOC_FROM_REPOS)
  set (HWLOC_FORCE_BUILD TRUE)
endif (HWLOC_FROM_REPOS)

if (NOT HWLOC_FOUND OR HWLOC_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (HWLOC_SOURCE ${HWLOC_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT HWLOC_SOURCE)
    set (HWLOC_SOURCE ${HWLOC_URL})
  endif (NOT HWLOC_SOURCE)
  
  ## Build package from source
  
  if (HWLOC_FROM_REPOS)
    
    ExternalProject_Add (hwloc
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${HWLOC_SVN}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ./autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (HWLOC_FROM_REPOS)
    
    ExternalProject_Add (hwloc
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${HWLOC_SOURCE}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ./autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (HWLOC_FROM_REPOS)
  
else (NOT HWLOC_FOUND OR HWLOC_FORCE_BUILD)
  
  add_custom_target (hwloc
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[hwloc] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HWLOC_FOUND OR HWLOC_FORCE_BUILD)
