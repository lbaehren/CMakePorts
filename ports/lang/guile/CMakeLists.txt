
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GUILE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GUILE_VERSION        "1.8.7" )
set (GUILE_SOURCE_ARCHIVE "guile-${GUILE_VERSION}.tar.gz" )
set (GUILE_URL            "ftp://ftp.mirror.nl/pub/mirror/gnu/guile/${GUILE_SOURCE_ARCHIVE}" )
set (GUILE_MD5            "" )
set (GUILE_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GUILE_FORCE_BUILD    "Force build and installation of package?" NO )
option (GUILE_FROM_REPOS     "Install package from repository?"         NO )
option (GUILE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GUILE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GUILE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGMP)
#include (FindGuile)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GUILE_FROM_REPOS)
  set (GUILE_FORCE_BUILD TRUE)
endif (GUILE_FROM_REPOS)

if (NOT GUILE_FOUND OR GUILE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GUILE_SOURCE ${GUILE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GUILE_SOURCE)
    set (GUILE_SOURCE ${GUILE_URL})
  endif (NOT GUILE_SOURCE)

  ## Build package from source

  set ( ENV{LDFLAGS} -L{CMAKE_INSTALL_PREFIX}/lib )
  
  ExternalProject_Add (guile
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${GUILE_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} LDFLAGS=-L{CMAKE_INSTALL_PREFIX}/lib
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT GUILE_FOUND OR GUILE_FORCE_BUILD)
  
  add_custom_target (guile
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[GUILE] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GUILE_FOUND OR GUILE_FORCE_BUILD)
## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "+------------------------------------------------------------+")

message (STATUS "[Guile] Configuration summary.")
message (STATUS " GMP includes  = ${GMP_INCLUDES}")
message (STATUS " GMP libraries = ${GMP_LIBRARIES}")

message (STATUS "+------------------------------------------------------------+")
