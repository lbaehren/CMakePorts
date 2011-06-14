
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBXML2)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBXML2_VERSION        "2.7.8" )
set (LIBXML2_SOURCE_ARCHIVE "libxml2-${LIBXML2_VERSION}.tar.gz" )
set (LIBXML2_URL            "ftp://xmlsoft.org/libxml2/${LIBXML2_SOURCE_ARCHIVE}" )
set (LIBXML2_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBXML2_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBXML2_FROM_REPOS     "Install package from repository?"         NO )
option (LIBXML2_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBXML2_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBXML2_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLIBXML2)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBXML2_FROM_REPOS)
  set (LIBXML2_FORCE_BUILD TRUE)
endif (LIBXML2_FROM_REPOS)

if (NOT LIBXML2_FOUND OR LIBXML2_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBXML2_SOURCE ${LIBXML2_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBXML2_SOURCE)
    set (LIBXML2_SOURCE ${LIBXML2_URL})
  endif (NOT LIBXML2_SOURCE)
  
  ## Build package from source
  
  if (LIBXML2_FROM_REPOS)
    
    ExternalProject_Add (libxml2
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBXML2_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (LIBXML2_FROM_REPOS)
    
    ExternalProject_Add (libxml2
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBXML2_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (LIBXML2_FROM_REPOS)
  
else (NOT LIBXML2_FOUND OR LIBXML2_FORCE_BUILD)
  
  add_custom_target (libxml2
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libxml2] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBXML2_FOUND OR LIBXML2_FORCE_BUILD)
