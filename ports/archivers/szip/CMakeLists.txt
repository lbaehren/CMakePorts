
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SZIP)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (SZIP_VERSION        "2.1" )
set (SZIP_SOURCE_ARCHIVE "szip-${SZIP_VERSION}.tar.gz" )
set (SZIP_URL            "http://www.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/${SZIP_SOURCE_ARCHIVE}" )
set (SZIP_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SZIP_FORCE_BUILD    "Force build and installation of package?" NO )
option (SZIP_FROM_REPOS     "Install package from repository?"         NO )
option (SZIP_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SZIP_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SZIP_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_path (SZIP_INCLUDES szip_adpt.h
  PATHS /usr /usr/local /sw ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

if (SZIP_INCLUDES)
  set (HAVE_SZIP YES)
endif (SZIP_INCLUDES)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT HAVE_SZIP OR SZIP_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (HAVE_SZIP_SOURCE ${SZIP_SOURCE_ARCHIVE}
    PATHS ${SZIP_SOURCE_DIR}
    )
  
  if (NOT HAVE_SZIP_SOURCE)
    set (HAVE_SZIP_SOURCE ${SZIP_URL})
  endif (NOT HAVE_SZIP_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (szip
    PREFIX ${SZIP_BINARY_DIR}
    DOWNLOAD_DIR ${SZIP_BINARY_DIR}/download
    SOURCE_DIR ${SZIP_BINARY_DIR}/source
    URL ${HAVE_SZIP_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${SZIP_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT HAVE_SZIP OR SZIP_FORCE_BUILD)
  
  add_custom_target (szip
    WORKING_DIRECTORY ${SZIP_BINARY_DIR}
    COMMENT "[SZIP] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_SZIP OR SZIP_FORCE_BUILD)
