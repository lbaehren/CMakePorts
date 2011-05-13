
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Curl)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================

set (Curl_VERSION        "7.21.0" )
set (Curl_SOURCE_ARCHIVE "curl-${Curl_VERSION}.tar.gz" )
set (Curl_URL            "http://curl.haxx.se/download/${Curl_SOURCE_ARCHIVE}" )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindCURL)

## SSL / OpenSSL

find_path (SSL_INCLUDES openssl/ssl2.h
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES include lib/openssl lib/openssl/include
  )

find_library (SSL_LIBRARIES ssl crypto
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES lib
  )

if (SSL_LIBRARIES)
  get_filename_component(SSL_LIBRARY_PATH ${SSL_LIBRARIES} PATH)
endif (SSL_LIBRARIES)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT CURL_FOUND)
  
  ## Locate source file to build from
  
  find_file (HAVE_Curl_SOURCE ${Curl_SOURCE_ARCHIVE}
    PATHS ${Curl_SOURCE_DIR}
    )
  
  if (NOT HAVE_Curl_SOURCE)
    set (HAVE_Curl_SOURCE ${Curl_URL})
  endif (NOT HAVE_Curl_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (curl
    PREFIX ${Curl_BINARY_DIR}
    DOWNLOAD_DIR ${Curl_BINARY_DIR}/download
    SOURCE_DIR ${Curl_BINARY_DIR}/source
    URL ${HAVE_Curl_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${Curl_BINARY_DIR}/source/configure prefix=${CMAKE_INSTALL_PREFIX} --with-ssl=${SSL_LIBRARY_PATH}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT CURL_FOUND)

    add_custom_target (curl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CURL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CURL_FOUND)
