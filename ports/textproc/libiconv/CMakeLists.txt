
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBICONV)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBICONV_VERSION        "1.13" )
set (LIBICONV_SOURCE_ARCHIVE "libiconv-${LIBICONV_VERSION}.tar.gz" )
set (LIBICONV_URL            "http://ftp.gnu.org/pub/gnu/libiconv/${LIBICONV_SOURCE_ARCHIVE}" )
set (LIBICONV_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBICONV_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBICONV_FROM_REPOS     "Install package from repository?"         NO )
option (LIBICONV_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBICONV_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBICONV_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLIBICONV)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBICONV_FROM_REPOS)
  set (LIBICONV_FORCE_BUILD TRUE)
endif (LIBICONV_FROM_REPOS)

if (NOT LIBICONV_FOUND OR LIBICONV_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBICONV_SOURCE ${LIBICONV_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBICONV_SOURCE)
    set (LIBICONV_SOURCE ${LIBICONV_URL})
  endif (NOT LIBICONV_SOURCE)
  
  ## Build package from source
  
  if (LIBICONV_FROM_REPOS)
    
    ExternalProject_Add (libiconv
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBICONV_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-extra-encodings --enable-static --disable-nls --enable-relocatable
      INSTALL_COMMAND sudo make install
      )
  
  else (LIBICONV_FROM_REPOS)
    
    ExternalProject_Add (libiconv
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBICONV_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-extra-encodings --enable-static --disable-nls --enable-relocatable
      INSTALL_COMMAND sudo make install
      )
    
  endif (LIBICONV_FROM_REPOS)
  
else (NOT LIBICONV_FOUND OR LIBICONV_FORCE_BUILD)
  
  add_custom_target (libiconv
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libiconv] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBICONV_FOUND OR LIBICONV_FORCE_BUILD)
