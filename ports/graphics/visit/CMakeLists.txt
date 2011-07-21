
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (VISIT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (VISIT_VERSION        "2.2.2" )
set (VISIT_SOURCE_ARCHIVE "visit${VISIT_VERSION}.tar.gz" )
set (VISIT_URL            "http://portal.nersc.gov/svn/visit/trunk/releases/${VISIT_VERSION}/${VISIT_SOURCE_ARCHIVE}" )
set (VISIT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (VISIT_FORCE_BUILD    "Force build and installation of package?" NO )
option (VISIT_FROM_REPOS     "Install package from repository?"         NO )
option (VISIT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (VISIT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (VISIT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindVISIT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (VISIT_FROM_REPOS)
  set (VISIT_FORCE_BUILD TRUE)
endif (VISIT_FROM_REPOS)

if (NOT VISIT_FOUND OR VISIT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (VISIT_SOURCE ${VISIT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT VISIT_SOURCE)
    set (VISIT_SOURCE ${VISIT_URL})
  endif (NOT VISIT_SOURCE)
  
  ## Build package from source
  
  if (VISIT_FROM_REPOS)
    
    ExternalProject_Add (visit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${VISIT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (VISIT_FROM_REPOS)
    
    ExternalProject_Add (visit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${VISIT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (VISIT_FROM_REPOS)
  
else (NOT VISIT_FOUND OR VISIT_FORCE_BUILD)
  
  add_custom_target (visit
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[VisIt] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT VISIT_FOUND OR VISIT_FORCE_BUILD)
