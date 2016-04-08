
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (AUTOCONF)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (AUTOCONF_VERSION        "2.67" )
set (AUTOCONF_SOURCE_ARCHIVE "autoconf-${AUTOCONF_VERSION}.tar.gz" )
set (AUTOCONF_URL            "ftp://ftp.mirror.nl/pub/mirror/gnu/autoconf/${AUTOCONF_SOURCE_ARCHIVE}" )
set (AUTOCONF_MD5            "" )
set (AUTOCONF_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (AUTOCONF_FORCE_BUILD    "Force build and installation of package?" NO )
option (AUTOCONF_FROM_REPOS     "Install package from repository?"         NO )
option (AUTOCONF_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (AUTOCONF_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (AUTOCONF_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindAutoconf)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (AUTOCONF_FROM_REPOS)
  set (AUTOCONF_FORCE_BUILD TRUE)
endif (AUTOCONF_FROM_REPOS)

if (NOT AUTOCONF_FOUND OR AUTOCONF_FORCE_BUILD)

  ## Locate source file to build from

  find_file (AUTOCONF_SOURCE ${AUTOCONF_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT AUTOCONF_SOURCE)
    set (AUTOCONF_SOURCE ${AUTOCONF_URL})
  endif (NOT AUTOCONF_SOURCE)

  ## Build package from source

  ExternalProject_Add (autoconf
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${AUTOCONF_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT AUTOCONF_FOUND OR AUTOCONF_FORCE_BUILD)

  add_custom_target (autoconf
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Autoconf] Found system-wide installation; skipping rebuild!"
    )

endif (NOT AUTOCONF_FOUND OR AUTOCONF_FORCE_BUILD)
