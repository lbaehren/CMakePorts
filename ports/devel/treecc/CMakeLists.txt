
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Treecc)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Treecc_VERSION        "0.3.10" )
set (Treecc_SOURCE_ARCHIVE "treecc-${Treecc_VERSION}.tar.gz" )
set (Treecc_URL            "http://mirror.lihnidos.org/GNU/savannah/dotgnu-pnet/${Treecc_SOURCE_ARCHIVE}" )
set (Treecc_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Treecc_FORCE_BUILD    "Force build and installation of package?" NO )
option (Treecc_FROM_REPOS     "Install package from repository?"         NO )
option (Treecc_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Treecc_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Treecc_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

set (TREECC_FIND_QUIETLY TRUE)

include (FindTreecc)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Treecc_FROM_REPOS)
  set (Treecc_FORCE_BUILD TRUE)
endif (Treecc_FROM_REPOS)

if (NOT TREECC_FOUND OR Treecc_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (TREECC_SOURCE ${Treecc_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT TREECC_SOURCE)
    set (TREECC_SOURCE ${Treecc_URL})
  endif (NOT TREECC_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (treecc
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    #  SVN_REPOSITORY ${Treecc_SVN}
    URL ${TREECC_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT TREECC_FOUND OR Treecc_FORCE_BUILD)
  
  add_custom_target (treecc
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Treecc] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT TREECC_FOUND OR Treecc_FORCE_BUILD)
