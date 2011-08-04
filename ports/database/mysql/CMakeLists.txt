
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (MYSQL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (MYSQL_VERSION        "5.5.9" )
set (MYSQL_SOURCE_ARCHIVE "mysql-${MYSQL_VERSION}.tar.gz" )
set (MYSQL_URL            "" )
set (MYSQL_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (MYSQL_FORCE_BUILD    "Force build and installation of package?" NO )
option (MYSQL_FROM_REPOS     "Install package from repository?"         NO )
option (MYSQL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (MYSQL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (MYSQL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindMySQL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (MYSQL_FROM_REPOS)
  set (MYSQL_FORCE_BUILD TRUE)
endif (MYSQL_FROM_REPOS)

if (NOT MYSQL_FOUND OR MYSQL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (MYSQL_SOURCE ${MYSQL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT MYSQL_SOURCE)
    set (MYSQL_SOURCE ${MYSQL_URL})
  endif (NOT MYSQL_SOURCE)
  
  ## Build package from source
  
  if (MYSQL_FROM_REPOS)
    
    ExternalProject_Add (mysql
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${MYSQL_SVN}
      CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (MYSQL_FROM_REPOS)
    
    ExternalProject_Add (mysql
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${MYSQL_SOURCE}
      CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (MYSQL_FROM_REPOS)
  
else (NOT MYSQL_FOUND OR MYSQL_FORCE_BUILD)
  
  add_custom_target (mysql
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[mysql] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT MYSQL_FOUND OR MYSQL_FORCE_BUILD)
