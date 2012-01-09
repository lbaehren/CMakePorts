
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SQLITE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SQLITE_VERSION        "3070900" )
set (SQLITE_SOURCE_ARCHIVE "sqlite-autoconf-${SQLITE_VERSION}.tar.gz" )
set (SQLITE_URL            "http://www.sqlite.org/${SQLITE_SOURCE_ARCHIVE}" )
set (SQLITE_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SQLITE_FORCE_BUILD    "Force build and installation of package?" NO )
option (SQLITE_FROM_REPOS     "Install package from repository?"         NO )
option (SQLITE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SQLITE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SQLITE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindSQLITE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SQLITE_FROM_REPOS)
  set (SQLITE_FORCE_BUILD TRUE)
endif (SQLITE_FROM_REPOS)

if (NOT SQLITE_FOUND OR SQLITE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SQLITE_SOURCE ${SQLITE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SQLITE_SOURCE)
    set (SQLITE_SOURCE ${SQLITE_URL})
  endif (NOT SQLITE_SOURCE)
  
  ## Build package from source
  
  if (SQLITE_FROM_REPOS)
    
    ExternalProject_Add (sqlite
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SQLITE_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (SQLITE_FROM_REPOS)
    
    ExternalProject_Add (sqlite
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SQLITE_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (SQLITE_FROM_REPOS)
  
else (NOT SQLITE_FOUND OR SQLITE_FORCE_BUILD)
  
  add_custom_target (sqlite
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[sqlite] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SQLITE_FOUND OR SQLITE_FORCE_BUILD)
