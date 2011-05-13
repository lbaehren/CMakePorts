
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBTOOL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBTOOL_VERSION        "2.4" )
set (LIBTOOL_SOURCE_ARCHIVE "libtool-${LIBTOOL_VERSION}.tar.gz" )
set (LIBTOOL_URL            "http://ftp.gnu.org/gnu/libtool/${LIBTOOL_SOURCE_ARCHIVE}" )
set (LIBTOOL_MD5            "" )
set (LIBTOOL_GIT            "git://git.savannah.gnu.org/libtool.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBTOOL_FORCE_BUILD    "Force build and installation of package?" NO  )
option (LIBTOOL_FROM_REPOS     "Install package from repository?"         YES )
option (LIBTOOL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBTOOL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBTOOL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLIBTOOL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBTOOL_FROM_REPOS)
  set (LIBTOOL_FORCE_BUILD TRUE)
endif (LIBTOOL_FROM_REPOS)

if (NOT LIBTOOL_FOUND OR LIBTOOL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBTOOL_SOURCE ${LIBTOOL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBTOOL_SOURCE)
    set (LIBTOOL_SOURCE ${LIBTOOL_URL})
  endif (NOT LIBTOOL_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (libtool
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    GIT_REPOSITORY ${LIBTOOL_GIT}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/bootstrap
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT LIBTOOL_FOUND OR LIBTOOL_FORCE_BUILD)
  
  add_custom_target (libtool
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[LIBTOOL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBTOOL_FOUND OR LIBTOOL_FORCE_BUILD)
