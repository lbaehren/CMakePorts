
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (DOXYGEN)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (DOXYGEN_VERSION        "1.7.6.1" )
set (DOXYGEN_SOURCE_ARCHIVE "doxygen-${DOXYGEN_VERSION}.src.tar.gz" )
set (DOXYGEN_URL            "http://ftp.stack.nl/pub/users/dimitri/${DOXYGEN_SOURCE_ARCHIVE}" )
set (DOXYGEN_SVN            "https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (DOXYGEN_FORCE_BUILD    "Force build and installation of package?" NO )
option (DOXYGEN_FROM_REPOS     "Install package from repository?"         NO )
option (DOXYGEN_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (DOXYGEN_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (DOXYGEN_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindDOXYGEN)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (DOXYGEN_FROM_REPOS)
  set (DOXYGEN_FORCE_BUILD TRUE)
endif (DOXYGEN_FROM_REPOS)

if (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (DOXYGEN_SOURCE ${DOXYGEN_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT DOXYGEN_SOURCE)
    set (DOXYGEN_SOURCE ${DOXYGEN_URL})
  endif (NOT DOXYGEN_SOURCE)
  
  ## Build package from source
  
  if (DOXYGEN_FROM_REPOS)
    
    ExternalProject_Add (doxygen
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${DOXYGEN_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix ${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (DOXYGEN_FROM_REPOS)
    
    ExternalProject_Add (doxygen
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${DOXYGEN_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix ${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (DOXYGEN_FROM_REPOS)
  
else (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)
  
  add_custom_target (doxygen
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[doxygen] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)
