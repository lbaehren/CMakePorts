
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBVPX)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBVPX_VERSION        "" )
set (LIBVPX_SOURCE_ARCHIVE "" )
set (LIBVPX_URL            "" )
set (LIBVPX_MD5            "" )
set (LIBVPX_GIT            "git://review.webmproject.org/libvpx.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBVPX_FORCE_BUILD    "Force build and installation of package?" NO  )
option (LIBVPX_FROM_REPOS     "Install package from repository?"         YES )
option (LIBVPX_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBVPX_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBVPX_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLIBVPX)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBVPX_FROM_REPOS)
  set (LIBVPX_FORCE_BUILD TRUE)
endif (LIBVPX_FROM_REPOS)

if (NOT LIBVPX_FOUND OR LIBVPX_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBVPX_SOURCE ${LIBVPX_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBVPX_SOURCE)
    set (LIBVPX_SOURCE ${LIBVPX_URL})
  endif (NOT LIBVPX_SOURCE)
  
  ## Build package from source
  
  if (LIBVPX_FROM_REPOS)
    
    ExternalProject_Add (libvpx
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${LIBVPX_GIT}
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  else (LIBVPX_FROM_REPOS)
    
    add_custom_target (libvpx
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
      COMMENT "[LIBVPX] No installation from static source defined!"
      )
    
  endif (LIBVPX_FROM_REPOS)
  
else (NOT LIBVPX_FOUND OR LIBVPX_FORCE_BUILD)
  
  add_custom_target (libvpx
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[LIBVPX] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBVPX_FOUND OR LIBVPX_FORCE_BUILD)
