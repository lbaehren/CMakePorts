
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (AUTOMAKE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (AUTOMAKE_VERSION        "1.11.1" )
set (AUTOMAKE_SOURCE_ARCHIVE "automake-${AUTOMAKE_VERSION}.tar.gz" )
set (AUTOMAKE_URL            "http://ftp.gnu.org/gnu/automake/${AUTOMAKE_SOURCE_ARCHIVE}" )
set (AUTOMAKE_MD5            "" )
set (AUTOMAKE_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (AUTOMAKE_FORCE_BUILD    "Force build and installation of package?" NO )
option (AUTOMAKE_FROM_REPOS     "Install package from repository?"         NO )
option (AUTOMAKE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (AUTOMAKE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (AUTOMAKE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (AUTOMAKE_EXECUTABLE automake
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin
  )

if (AUTOMAKE_EXECUTABLE)
  set (AUTOMAKE_FOUND TRUE)
endif (AUTOMAKE_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (AUTOMAKE_FROM_REPOS)
  set (AUTOMAKE_FORCE_BUILD TRUE)
endif (AUTOMAKE_FROM_REPOS)

if (NOT AUTOMAKE_FOUND OR AUTOMAKE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (AUTOMAKE_SOURCE ${AUTOMAKE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT AUTOMAKE_SOURCE)
    set (AUTOMAKE_SOURCE ${AUTOMAKE_URL})
  endif (NOT AUTOMAKE_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (automake
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${AUTOMAKE_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT AUTOMAKE_FOUND OR AUTOMAKE_FORCE_BUILD)
  
  add_custom_target (automake
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Automake] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT AUTOMAKE_FOUND OR AUTOMAKE_FORCE_BUILD)
