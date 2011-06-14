
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (VALGRIND)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (VALGRIND_VERSION        "3.6.1" )
set (VALGRIND_SOURCE_ARCHIVE "valgrind-${VALGRIND_VERSION}.tar.bz2" )
set (VALGRIND_URL            "http://valgrind.org/downloads/${VALGRIND_SOURCE_ARCHIVE}" )
set (VALGRIND_SVN            "svn://svn.valgrind.org/valgrind/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (VALGRIND_FORCE_BUILD    "Force build and installation of package?" NO  )
option (VALGRIND_FROM_REPOS     "Install package from repository?"         YES )
option (VALGRIND_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (VALGRIND_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (VALGRIND_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindValgrind)

#CC="gcc -arch i386" CXX="g++ -arch i386"

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (VALGRIND_FROM_REPOS)
  set (VALGRIND_FORCE_BUILD TRUE)
endif (VALGRIND_FROM_REPOS)

if (NOT VALGRIND_FOUND OR VALGRIND_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (VALGRIND_SOURCE ${VALGRIND_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT VALGRIND_SOURCE)
    set (VALGRIND_SOURCE ${VALGRIND_URL})
  endif (NOT VALGRIND_SOURCE)
  
  ## Build package from source
  
  if (VALGRIND_FROM_REPOS)
    
    ExternalProject_Add (valgrind
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${VALGRIND_SVN}
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-dependency-tracking
      INSTALL_COMMAND sudo make install
      )
  
  else (VALGRIND_FROM_REPOS)
    
    ExternalProject_Add (valgrind
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${VALGRIND_SOURCE}
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-dependency-tracking
      INSTALL_COMMAND sudo make install
      )
    
  endif (VALGRIND_FROM_REPOS)
  
else (NOT VALGRIND_FOUND OR VALGRIND_FORCE_BUILD)
  
  add_custom_target (valgrind
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Valgrind] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT VALGRIND_FOUND OR VALGRIND_FORCE_BUILD)
