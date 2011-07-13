
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PPL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (PPL_VERSION        "0.11" )
set (PPL_SOURCE_ARCHIVE "ppl-${PPL_VERSION}.tar.gz" )
set (PPL_URL            "ftp://ftp.cs.unipr.it/pub/ppl/releases/${PPL_VERSION}/${PPL_SOURCE_ARCHIVE}" )
set (PPL_GIT            "git://git.cs.unipr.it/ppl/ppl.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PPL_FORCE_BUILD    "Force build and installation of package?" NO )
option (PPL_FROM_REPOS     "Install package from repository?"         NO )
option (PPL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (PPL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (PPL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindPPL)
include (FindGMP)

if (GMP_FOUND)
  find_path (GMP_PREFIX include/gmp.h include/gmpxx.h
    PATHS /sw /usr /usr/local ${CMAKE_INSTALL_PREFIX}
    )
endif (GMP_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (PPL_FROM_REPOS)
  set (PPL_FORCE_BUILD TRUE)
endif (PPL_FROM_REPOS)

if (NOT PPL_FOUND OR PPL_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (PPL_SOURCE ${PPL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT PPL_SOURCE)
    set (PPL_SOURCE ${PPL_URL})
  endif (NOT PPL_SOURCE)
  
  ## Build package from source

  if (PPL_FROM_REPOS)
  
    ExternalProject_Add (ppl
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${PPL_GIT}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND cd ${PROJECT_BINARY_DIR}/source && autoconf
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-gmp-prefix=${GMP_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  else (PPL_FROM_REPOS)
    
    ExternalProject_Add (ppl
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${PPL_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-gmp-prefix=${GMP_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  endif (PPL_FROM_REPOS)
  
else (NOT PPL_FOUND OR PPL_FORCE_BUILD)
  
  add_custom_target (ppl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[PPL] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT PPL_FOUND OR PPL_FORCE_BUILD)
