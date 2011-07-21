
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TMF)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (TMF_VERSION        "" )
set (TMF_SOURCE_ARCHIVE "" )
set (TMF_URL            "" )
set (TMF_GIT            "git://github.com/pschella/tmf.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (TMF_FORCE_BUILD    "Force build and installation of package?" NO  )
option (TMF_FROM_REPOS     "Install package from repository?"         YES )
option (TMF_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (TMF_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (TMF_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindTMF)
include (FindPython)

find_program (SWIG_EXECUTABLE swig
  HINTS ${SWIG_ROOT_DIR}
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES bin
  )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (TMF_FROM_REPOS)
  set (TMF_FORCE_BUILD TRUE)
endif (TMF_FROM_REPOS)

if (NOT TMF_FOUND OR TMF_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (TMF_SOURCE ${TMF_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT TMF_SOURCE)
    set (TMF_SOURCE ${TMF_URL})
  endif (NOT TMF_SOURCE)
  
  ## Build package from source
  
  if (TMF_FROM_REPOS)
    
    ExternalProject_Add (tmf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${TMF_GIT}
      CMAKE_ARGS -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE} -DPYTHON_INCLUDE_PATH=${PYTHON_INCLUDES} -DPYTHON_LIBRARIES=${PYTHON_LIBRARIES} -DPYTHONLIBS_FOUND=TRUE -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (TMF_FROM_REPOS)
    
    ExternalProject_Add (tmf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${TMF_SOURCE}
      CMAKE_ARGS -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE} -DPYTHON_INCLUDE_PATH=${PYTHON_INCLUDES} -DPYTHON_LIBRARIES=${PYTHON_LIBRARIES} -DPYTHONLIBS_FOUND=TRUE -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (TMF_FROM_REPOS)
  
else (NOT TMF_FOUND OR TMF_FORCE_BUILD)
  
  add_custom_target (tmf
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[TMF] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT TMF_FOUND OR TMF_FORCE_BUILD)
