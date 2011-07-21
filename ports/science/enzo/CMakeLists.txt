
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (ENZO)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (ENZO_VERSION        "1.0.1" )
set (ENZO_SOURCE_ARCHIVE "enzo-${ENZO_VERSION}.tar.gz" )
set (ENZO_URL            "http://lca.ucsd.edu/software/enzo/v${ENZO_VERSION}/download/${ENZO_SOURCE_ARCHIVE}" )
set (ENZO_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ENZO_FORCE_BUILD    "Force build and installation of package?" NO )
option (ENZO_FROM_REPOS     "Install package from repository?"         NO )
option (ENZO_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (ENZO_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (ENZO_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindENZO)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (ENZO_FROM_REPOS)
  set (ENZO_FORCE_BUILD TRUE)
endif (ENZO_FROM_REPOS)

if (NOT ENZO_FOUND OR ENZO_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (ENZO_SOURCE ${ENZO_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT ENZO_SOURCE)
    set (ENZO_SOURCE ${ENZO_URL})
  endif (NOT ENZO_SOURCE)
  
  ## Build package from source
  
  if (ENZO_FROM_REPOS)
    
    ExternalProject_Add (enzo
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${ENZO_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (ENZO_FROM_REPOS)
    
    ExternalProject_Add (enzo
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${ENZO_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (ENZO_FROM_REPOS)
  
else (NOT ENZO_FOUND OR ENZO_FORCE_BUILD)
  
  add_custom_target (enzo
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[ENZO] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT ENZO_FOUND OR ENZO_FORCE_BUILD)
