
## ==============================================================================
##
##  CMake project settings & description
##
##  log4cplus is a simple to use C++ logging API providing thread-safe, flexible,
##  and arbitrarily granular control over log management and configuration. It is
##  modelled after the Java log4j API.
##
## ==============================================================================

## Name of the project handled by CMake
project (LOG4CPLUS)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LOG4CPLUS_VERSION        "1.0.4" )
set (LOG4CPLUS_SOURCE_ARCHIVE "log4cplus-${LOG4CPLUS_VERSION}.tar.bz2" )
set (LOG4CPLUS_URL            "http://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/${LOG4CPLUS_VERSION}/${LOG4CPLUS_SOURCE_ARCHIVE}" )
set (LOG4CPLUS_SVN            "https://log4cplus.svn.sourceforge.net/svnroot/log4cplus" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LOG4CPLUS_FORCE_BUILD    "Force build and installation of package?" NO )
option (LOG4CPLUS_FROM_REPOS     "Install package from repository?"         NO )
option (LOG4CPLUS_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LOG4CPLUS_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LOG4CPLUS_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLOG4CPLUS)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LOG4CPLUS_FROM_REPOS)
  set (LOG4CPLUS_FORCE_BUILD TRUE)
endif (LOG4CPLUS_FROM_REPOS)

if (NOT LOG4CPLUS_FOUND OR LOG4CPLUS_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LOG4CPLUS_SOURCE ${LOG4CPLUS_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LOG4CPLUS_SOURCE)
    set (LOG4CPLUS_SOURCE ${LOG4CPLUS_URL})
  endif (NOT LOG4CPLUS_SOURCE)
  
  ## Build package from source
  
  if (LOG4CPLUS_FROM_REPOS)
    
    ExternalProject_Add (log4cplus
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LOG4CPLUS_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (LOG4CPLUS_FROM_REPOS)
    
    ExternalProject_Add (log4cplus
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LOG4CPLUS_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (LOG4CPLUS_FROM_REPOS)
  
else (NOT LOG4CPLUS_FOUND OR LOG4CPLUS_FORCE_BUILD)
  
  add_custom_target (log4cplus
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[log4cplus] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LOG4CPLUS_FOUND OR LOG4CPLUS_FORCE_BUILD)
