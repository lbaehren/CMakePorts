
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (OpenSSL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (OpenSSL_VERSION        "1.0.0a" )
set (OpenSSL_SOURCE_ARCHIVE "openssl-${OpenSSL_VERSION}.tar.gz" )
set (OpenSSL_URL            "http://www.openssl.org/source/${OpenSSL_SOURCE_ARCHIVE}" )
set (OpenSSL_SVN            "" )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindOpenSSL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (OpenSSL_FROM_REPOS)
  set (OpenSSL_FORCE_BUILD TRUE)
endif (OpenSSL_FROM_REPOS)

if (NOT OPENSSL_FOUND OR OpenSSL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (OPENSSL_FOUND_SOURCE ${OpenSSL_SOURCE_ARCHIVE}
    PATHS ${OpenSSL_SOURCE_DIR}
    )
  
  if (NOT OPENSSL_FOUND_SOURCE)
    set (OPENSSL_FOUND_SOURCE ${OpenSSL_URL})
  endif (NOT OPENSSL_FOUND_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (openssl
    PREFIX ${OpenSSL_BINARY_DIR}
    DOWNLOAD_DIR ${OpenSSL_BINARY_DIR}/download
    SOURCE_DIR ${OpenSSL_BINARY_DIR}/source
    URL ${OPENSSL_FOUND_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${OpenSSL_BINARY_DIR}/source/config --openssldir=${CMAKE_INSTALL_PREFIX}/lib/openssl
    INSTALL_COMMAND sudo make install
    )
  
else (NOT OPENSSL_FOUND OR OpenSSL_FORCE_BUILD)
  
  add_custom_target (openssl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[OpenSSL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT OPENSSL_FOUND OR OpenSSL_FORCE_BUILD)
