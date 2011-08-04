
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CGAL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (CGAL_VERSION        "3.8" )
set (CGAL_SOURCE_ARCHIVE "CGAL-${CGAL_VERSION}.tar.gz" )
set (CGAL_URL            "https://gforge.inria.fr/frs/download.php/28500/${CGAL_SOURCE_ARCHIVE}" )
set (CGAL_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CGAL_FORCE_BUILD    "Force build and installation of package?" NO )
option (CGAL_FROM_REPOS     "Install package from repository?"         NO )
option (CGAL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CGAL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CGAL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindCGAL)
include (FindMPFR)
include (FindGMP)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CGAL_FROM_REPOS)
  set (CGAL_FORCE_BUILD TRUE)
endif (CGAL_FROM_REPOS)

if (NOT CGAL_FOUND OR CGAL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (CGAL_SOURCE ${CGAL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT CGAL_SOURCE)
    set (CGAL_SOURCE ${CGAL_URL})
  endif (NOT CGAL_SOURCE)
  
  ## Build package from source
  
  if (CGAL_FROM_REPOS)
    
    ExternalProject_Add (cgal
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${CGAL_SVN}
      CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (CGAL_FROM_REPOS)
    
    ExternalProject_Add (cgal
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${CGAL_SOURCE}
      CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (CGAL_FROM_REPOS)
  
else (NOT CGAL_FOUND OR CGAL_FORCE_BUILD)
  
  add_custom_target (cgal
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CGAL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CGAL_FOUND OR CGAL_FORCE_BUILD)
