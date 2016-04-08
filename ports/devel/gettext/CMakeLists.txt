
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GETTEXT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (GETTEXT_VERSION        "0.18" )
set (GETTEXT_SOURCE_ARCHIVE "gettext-${GETTEXT_VERSION}.tar.gz" )
set (GETTEXT_URL            "ftp://ftp.mirror.nl/pub/mirror/gnu/gettext/${GETTEXT_SOURCE_ARCHIVE}" )
set (GETTEXT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GETTEXT_FORCE_BUILD    "Force build and installation of package?" NO )
option (GETTEXT_FROM_REPOS     "Install package from repository?"         NO )
option (GETTEXT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GETTEXT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GETTEXT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindGETTEXT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GETTEXT_FROM_REPOS)
  set (GETTEXT_FORCE_BUILD TRUE)
endif (GETTEXT_FROM_REPOS)

if (NOT GETTEXT_FOUND OR GETTEXT_FORCE_BUILD)

  ## Locate source file to build from

  find_file (GETTEXT_SOURCE ${GETTEXT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT GETTEXT_SOURCE)
    set (GETTEXT_SOURCE ${GETTEXT_URL})
  endif (NOT GETTEXT_SOURCE)

  ## Build package from source

  if (GETTEXT_FROM_REPOS)

    ExternalProject_Add (gettext
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${GETTEXT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (GETTEXT_FROM_REPOS)

    ExternalProject_Add (gettext
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GETTEXT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  endif (GETTEXT_FROM_REPOS)

else (NOT GETTEXT_FOUND OR GETTEXT_FORCE_BUILD)

  add_custom_target (gettext
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[gettext] Found system-wide installation; skipping rebuild!"
    )

endif (NOT GETTEXT_FOUND OR GETTEXT_FORCE_BUILD)
