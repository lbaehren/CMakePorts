
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SERF)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SERF_VERSION        "1.0.0" )
set (SERF_SOURCE_ARCHIVE "serf-${SERF_VERSION}.tar.gz" )
set (SERF_URL            "http://serf.googlecode.com/files/${SERF_SOURCE_ARCHIVE}" )
set (SERF_SVN            "http://serf.googlecode.com/svn/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SERF_FORCE_BUILD    "Force build and installation of package?" NO )
option (SERF_FROM_REPOS     "Install package from repository?"         NO )
option (SERF_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SERF_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SERF_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindAPR)

## Extract base directory of APR installation

if (APR_LIBRARIES)
  get_filename_component (APR_LIBRARY_DIR ${APR_LIBRARIES} PATH)
endif (APR_LIBRARIES)

if (APR_LIBRARY_DIR)
  set (APR_PREFIX ${APR_LIBRARY_DIR}/..)
else (APR_LIBRARY_DIR)
  set (APR_PREFIX ${CMAKE_INSTALL_PREFIX})
endif (APR_LIBRARY_DIR)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SERF_FROM_REPOS)
  set (SERF_FORCE_BUILD TRUE)
endif (SERF_FROM_REPOS)

if (NOT SERF_FOUND OR SERF_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SERF_SOURCE ${SERF_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SERF_SOURCE)
    set (SERF_SOURCE ${SERF_URL})
  endif (NOT SERF_SOURCE)
  
  ## Build package from source
  
  if (SERF_FROM_REPOS)
    
    ExternalProject_Add (serf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SERF_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${APR_PREFIX} --with-openssl=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (SERF_FROM_REPOS)
    
    ExternalProject_Add (serf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SERF_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${APR_PREFIX} --with-openssl=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (SERF_FROM_REPOS)
  
else (NOT SERF_FOUND OR SERF_FORCE_BUILD)
  
  add_custom_target (serf
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[serf] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SERF_FOUND OR SERF_FORCE_BUILD)
