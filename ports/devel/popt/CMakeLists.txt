
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (POPT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (POPT_VERSION        "1.16" )
set (POPT_SOURCE_ARCHIVE "popt-${POPT_VERSION}.tar.gz" )
set (POPT_URL            "http://rpm5.org/files/popt/${POPT_SOURCE_ARCHIVE}" )
set (POPT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (POPT_FORCE_BUILD    "Force build and installation of package?" NO )
option (POPT_FROM_REPOS     "Install package from repository?"         NO )
option (POPT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (POPT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (POPT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindPOPT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (POPT_FROM_REPOS)
  set (POPT_FORCE_BUILD TRUE)
endif (POPT_FROM_REPOS)

if (NOT POPT_FOUND OR POPT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (POPT_SOURCE ${POPT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT POPT_SOURCE)
    set (POPT_SOURCE ${POPT_URL})
  endif (NOT POPT_SOURCE)
  
  ## Build package from source
  
  if (POPT_FROM_REPOS)
    
    ExternalProject_Add (popt
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${POPT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (POPT_FROM_REPOS)
    
    ExternalProject_Add (popt
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${POPT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (POPT_FROM_REPOS)
  
else (NOT POPT_FOUND OR POPT_FORCE_BUILD)
  
  add_custom_target (popt
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[popt] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT POPT_FOUND OR POPT_FORCE_BUILD)
