
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (EXPAT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (EXPAT_VERSION        "2.0.1" )
set (EXPAT_SOURCE_ARCHIVE "expat-${EXPAT_VERSION}.tar.gz" )
set (EXPAT_URL            "http://downloads.sourceforge.net/project/expat/expat/${EXPAT_VERSION}/${EXPAT_SOURCE_ARCHIVE}" )
set (EXPAT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (EXPAT_FORCE_BUILD    "Force build and installation of package?" NO )
option (EXPAT_FROM_REPOS     "Install package from repository?"         NO )
option (EXPAT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (EXPAT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (EXPAT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindEXPAT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (EXPAT_FROM_REPOS)
  set (EXPAT_FORCE_BUILD TRUE)
endif (EXPAT_FROM_REPOS)

if (NOT EXPAT_FOUND OR EXPAT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (EXPAT_SOURCE ${EXPAT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT EXPAT_SOURCE)
    set (EXPAT_SOURCE ${EXPAT_URL})
  endif (NOT EXPAT_SOURCE)
  
  ## Build package from source
  
  if (EXPAT_FROM_REPOS)
    
    ExternalProject_Add (expat
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${EXPAT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (EXPAT_FROM_REPOS)
    
    ExternalProject_Add (expat
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${EXPAT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (EXPAT_FROM_REPOS)
  
else (NOT EXPAT_FOUND OR EXPAT_FORCE_BUILD)
  
  add_custom_target (expat
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[EXPAT] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT EXPAT_FOUND OR EXPAT_FORCE_BUILD)
