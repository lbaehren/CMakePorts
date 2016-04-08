
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (READLINE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (READLINE_VERSION        "6.1" )
set (READLINE_SOURCE_ARCHIVE "readline-${READLINE_VERSION}.tar.gz" )
set (READLINE_URL            "ftp://ftp.cwru.edu/pub/bash/${READLINE_SOURCE_ARCHIVE}" )
set (READLINE_MD5            "" )
set (READLINE_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (READLINE_FORCE_BUILD    "Force build and installation of package?" NO )
option (READLINE_FROM_REPOS     "Install package from repository?"         NO )
option (READLINE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (READLINE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (READLINE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindReadline)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (READLINE_FROM_REPOS)
  set (READLINE_FORCE_BUILD TRUE)
endif (READLINE_FROM_REPOS)

if (NOT READLINE_FOUND OR READLINE_FORCE_BUILD)

  ## Locate source file to build from

  find_file (READLINE_SOURCE ${READLINE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT READLINE_SOURCE)
    set (READLINE_SOURCE ${READLINE_URL})
  endif (NOT READLINE_SOURCE)

  ## Build package from source

  ExternalProject_Add (readline
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${READLINE_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT READLINE_FOUND OR READLINE_FORCE_BUILD)

  add_custom_target (readline
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[readline] Found system-wide installation; skipping rebuild!"
    )

endif (NOT READLINE_FOUND OR READLINE_FORCE_BUILD)
