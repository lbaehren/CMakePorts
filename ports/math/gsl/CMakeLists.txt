
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GSL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GSL_VERSION        "1.14" )
set (GSL_SOURCE_ARCHIVE "gsl-${GSL_VERSION}.tar.gz" )
set (GSL_URL            "ftp://ftp.gnu.org/gnu/gsl/${GSL_SOURCE_ARCHIVE}" )
set (GSL_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GSL_FORCE_BUILD    "Force build and installation of package?" NO )
option (GSL_FROM_REPOS     "Install package from repository?"         NO )
option (GSL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GSL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GSL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGSL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GSL_FROM_REPOS)
  set (GSL_FORCE_BUILD TRUE)
endif (GSL_FROM_REPOS)

if (NOT GSL_FOUND OR GSL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GSL_SOURCE ${GSL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GSL_SOURCE)
    set (GSL_SOURCE ${GSL_URL})
  endif (NOT GSL_SOURCE)
  
  ## Build package from source
  
  if (GSL_FROM_REPOS)
    
    ExternalProject_Add (gsl
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${GSL_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (GSL_FROM_REPOS)
    
    ExternalProject_Add (gsl
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GSL_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (GSL_FROM_REPOS)
  
else (NOT GSL_FOUND OR GSL_FORCE_BUILD)
  
  add_custom_target (gsl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[GSL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GSL_FOUND OR GSL_FORCE_BUILD)
