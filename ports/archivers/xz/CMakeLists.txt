
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (XZ)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (XZ_VERSION        "5.0.3")
set (XZ_SOURCE_ARCHIVE "xz-${XZ_VERSION}.tar.gz")
set (XZ_URL            "http://tukaani.org/xz/${XZ_SOURCE_ARCHIVE}" )
set (XZ_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (XZ_FORCE_BUILD    "Force build and installation of package?" NO )
option (XZ_FROM_REPOS     "Install package from repository?"         NO )
option (XZ_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (XZ_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (XZ_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindXZ)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (XZ_FROM_REPOS)
  set (XZ_FORCE_BUILD TRUE)
endif (XZ_FROM_REPOS)

if (NOT XZ_FOUND OR XZ_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (XZ_SOURCE ${XZ_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT XZ_SOURCE)
    set (XZ_SOURCE ${XZ_URL})
  endif (NOT XZ_SOURCE)
  
  ## Build package from source
  
  if (XZ_FROM_REPOS)
    
    ExternalProject_Add (xz
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${XZ_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (XZ_FROM_REPOS)
    
    ExternalProject_Add (xz
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${XZ_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (XZ_FROM_REPOS)
  
else (NOT XZ_FOUND OR XZ_FORCE_BUILD)
  
  add_custom_target (xz
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[XZ] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT XZ_FOUND OR XZ_FORCE_BUILD)
