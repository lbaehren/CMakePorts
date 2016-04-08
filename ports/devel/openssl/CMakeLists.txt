
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (OPENSSL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

## Package information
set (OPENSSL_VERSION        "1.0.0a" )
set (OPENSSL_SOURCE_ARCHIVE "openssl-${OPENSSL_VERSION}.tar.gz" )
set (OPENSSL_URL            "http://www.openssl.org/source/${OPENSSL_SOURCE_ARCHIVE}" )
set (OPENSSL_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (OPENSSL_FORCE_BUILD    "Force build and installation of package?" NO )
option (OPENSSL_FROM_REPOS     "Install package from repository?"         NO )
option (OPENSSL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (OPENSSL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (OPENSSL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

set (OPENSSL_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
include (FindOpenSSL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (OPENSSL_FROM_REPOS)
  set (OPENSSL_FORCE_BUILD TRUE)
endif (OPENSSL_FROM_REPOS)

if (NOT OPENSSL_FOUND OR OPENSSL_FORCE_BUILD)

  ## Locate source file to build from

  find_file (OPENSSL_FOUND_SOURCE ${OPENSSL_SOURCE_ARCHIVE}
    PATHS ${OPENSSL_SOURCE_DIR}
    )

  if (NOT OPENSSL_FOUND_SOURCE)
    set (OPENSSL_FOUND_SOURCE ${OPENSSL_URL})
  endif (NOT OPENSSL_FOUND_SOURCE)

  ## Build package from source

  ExternalProject_Add (openssl
    PREFIX ${OPENSSL_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${OPENSSL_FOUND_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${OPENSSL_BINARY_DIR}/source/config --openssldir=${CMAKE_INSTALL_PREFIX}/lib/openssl
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT OPENSSL_FOUND OR OPENSSL_FORCE_BUILD)

  add_custom_target (openssl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[OpenSSL] Found system-wide installation; skipping rebuild!"
    )

endif (NOT OPENSSL_FOUND OR OPENSSL_FORCE_BUILD)
