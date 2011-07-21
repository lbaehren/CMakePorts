
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Wget)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Wget_VERSION        "1.12" )
set (Wget_SOURCE_ARCHIVE "wget-${Wget_VERSION}.tar.gz" )
set (Wget_URL            "http://ftp.gnu.org/gnu/wget/wget-latest.tar.gz" )
set (Wget_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Wget_FORCE_BUILD "Force build and installation of package?" NO )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (HAVE_Wget wget
  PATHS /sw /usr /usr/local /opt ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin
  )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT HAVE_Wget OR Wget_FORCE_BUILD)

## Locate source file to build from

find_file (HAVE_Wget_SOURCE ${Wget_SOURCE_ARCHIVE}
  PATHS ${Wget_SOURCE_DIR}
  )

if (NOT HAVE_Wget_SOURCE)
  set (HAVE_Wget_SOURCE ${Wget_URL})
endif (NOT HAVE_Wget_SOURCE)

## Build package from source

ExternalProject_Add (wget
  PREFIX ${Wget_BINARY_DIR}
  DOWNLOAD_DIR ${Wget_BINARY_DIR}/download
  SOURCE_DIR ${Wget_BINARY_DIR}/source
  URL ${HAVE_Wget_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${Wget_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
  )

else (NOT HAVE_Wget OR Wget_FORCE_BUILD)
  
  add_custom_target (wget
    WORKING_DIRECTORY ${Wget_BINARY_DIR}
    COMMENT "[Wget] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_Wget OR Wget_FORCE_BUILD)
