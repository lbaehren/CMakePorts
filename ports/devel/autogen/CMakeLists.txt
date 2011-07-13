
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (AUTOGEN)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (AUTOGEN_VERSION        "5.2.11" )
set (AUTOGEN_SOURCE_ARCHIVE "autogen-${AUTOGEN_VERSION}.tar.gz" )
set (AUTOGEN_URL            "ftp://ftp.mirror.nl/pub/mirror/gnu/autogen/${AUTOGEN_SOURCE_ARCHIVE}" )
set (AUTOGEN_MD5            "" )
set (AUTOGEN_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (AUTOGEN_FORCE_BUILD    "Force build and installation of package?" NO )
option (AUTOGEN_FROM_REPOS     "Install package from repository?"         NO )
option (AUTOGEN_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (AUTOGEN_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (AUTOGEN_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindAutogen)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (AUTOGEN_FROM_REPOS)
  set (AUTOGEN_FORCE_BUILD TRUE)
endif (AUTOGEN_FROM_REPOS)

if (NOT AUTOGEN_FOUND OR AUTOGEN_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (AUTOGEN_SOURCE ${AUTOGEN_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT AUTOGEN_SOURCE)
    set (AUTOGEN_SOURCE ${AUTOGEN_URL})
  endif (NOT AUTOGEN_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (autogen
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${AUTOGEN_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT AUTOGEN_FOUND OR AUTOGEN_FORCE_BUILD)
  
  add_custom_target (autogen
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[AUTOGEN] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT AUTOGEN_FOUND OR AUTOGEN_FORCE_BUILD)
