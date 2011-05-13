
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (APR)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (APR_VERSION        "1.4.4" )
set (APR_SOURCE_ARCHIVE "apr-${APR_VERSION}.tar.gz" )
set (APR_URL            "http://mirror.hostfuss.com/apache//apr/${APR_SOURCE_ARCHIVE}" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (APR_FORCE_BUILD    "Force build and installation of package?" NO )
option (APR_FROM_REPOS     "Install package from repository?"         NO )
option (APR_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (APR_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (APR_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindAPR)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (APR_FROM_REPOS)
  set (APR_FORCE_BUILD TRUE)
endif (APR_FROM_REPOS)

if (NOT APR_FOUND OR APR_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (APR_FOUND_SOURCE ${APR_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT APR_FOUND_SOURCE)
    set (APR_FOUND_SOURCE ${APR_URL})
  endif (NOT APR_FOUND_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (apr
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${APR_FOUND_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT APR_FOUND OR APR_FORCE_BUILD)
  
  add_custom_target (apr
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[APR] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT APR_FOUND OR APR_FORCE_BUILD)
