
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Serf)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Serf_VERSION        "0.7.2" )
set (Serf_SOURCE_ARCHIVE "serf-${Serf_VERSION}.tar.gz" )
set (Serf_URL            "http://serf.googlecode.com/files/${Serf_SOURCE_ARCHIVE}" )
set (Serf_SVN            "http://serf.googlecode.com/svn/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Serf_FORCE_BUILD    "Force build and installation of package?" NO  )
option (Serf_FROM_REPOS     "Install package from repository?"         NO  )
option (Serf_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Serf_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Serf_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindSerf)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Serf_FROM_REPOS)
  set (Serf_FORCE_BUILD TRUE)
endif (Serf_FROM_REPOS)

if (NOT HAVE_Serf OR Serf_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (HAVE_Serf_SOURCE ${Serf_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT HAVE_Serf_SOURCE)
    set (HAVE_Serf_SOURCE ${Serf_URL})
  endif (NOT HAVE_Serf_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (serf
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    #  SVN_REPOSITORY ${Serf_SVN}
    URL ${HAVE_Serf_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${CMAKE_INSTALL_PREFIX} --with-apr-util=${CMAKE_INSTALL_PREFIX} --with-openssl=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT HAVE_Serf OR Serf_FORCE_BUILD)
  
  add_custom_target (serf
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Serf] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_Serf OR Serf_FORCE_BUILD)
