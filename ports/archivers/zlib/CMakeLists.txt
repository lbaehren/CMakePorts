
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (ZLIB)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (ZLIB_VERSION        "1.2.5" )
set (ZLIB_SOURCE_ARCHIVE "zlib-${ZLIB_VERSION}.tar.gz" )
set (ZLIB_URL            "http://zlib.net/${ZLIB_SOURCE_ARCHIVE}" )
set (ZLIB_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ZLIB_FORCE_BUILD    "Force build and installation of package?" NO )
option (ZLIB_FROM_REPOS     "Install package from repository?"         NO )
option (ZLIB_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (ZLIB_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (ZLIB_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindZLIB)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (ZLIB_FROM_REPOS)
  set (ZLIB_FORCE_BUILD TRUE)
endif (ZLIB_FROM_REPOS)

if (NOT ZLIB_FOUND OR ZLIB_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (ZLIB_SOURCE ${ZLIB_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT ZLIB_SOURCE)
    set (ZLIB_SOURCE ${ZLIB_URL})
  endif (NOT ZLIB_SOURCE)
  
  ## Build package from source
  
  if (ZLIB_FROM_REPOS)
    
    ExternalProject_Add (zlib
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${ZLIB_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (ZLIB_FROM_REPOS)
    
    ExternalProject_Add (zlib
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${ZLIB_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (ZLIB_FROM_REPOS)
  
else (NOT ZLIB_FOUND OR ZLIB_FORCE_BUILD)
  
  add_custom_target (zlib
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[zlib] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT ZLIB_FOUND OR ZLIB_FORCE_BUILD)
