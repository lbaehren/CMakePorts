
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Bison)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (Bison_VERSION        "2.6" )
set (Bison_SOURCE_ARCHIVE "bison-${Bison_VERSION}.tar.gz" )
set (Bison_URL            "http://ftp.gnu.org/gnu/bison/${Bison_SOURCE_ARCHIVE}" )
set (Bison_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Bison_FORCE_BUILD    "Force build and installation of package?" NO )
option (Bison_FROM_REPOS     "Install package from repository?"         NO )
option (Bison_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (BISON_EXECUTABLE bison
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin
  )

if (BISON_EXECUTABLE)
  set (BISON_FOUND YES)
else (BISON_EXECUTABLE)
  set (BISON_FOUND NO)
endif (BISON_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT BISON_FOUND OR Bison_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (HAVE_Bison_SOURCE ${Bison_SOURCE_ARCHIVE}
    PATHS ${Bison_SOURCE_DIR}
    )
  
  if (NOT HAVE_Bison_SOURCE)
    set (HAVE_Bison_SOURCE ${Bison_URL})
  endif (NOT HAVE_Bison_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (bison
    PREFIX ${Bison_BINARY_DIR}
    DOWNLOAD_DIR ${Bison_BINARY_DIR}/download
    SOURCE_DIR ${Bison_BINARY_DIR}/source
    URL ${HAVE_Bison_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${Bison_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )
  
else (NOT BISON_FOUND OR Bison_FORCE_BUILD)
  
  add_custom_target (bison
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Bison] Found system-wide installation; skipping rebuild!"
    )

endif (NOT BISON_FOUND OR Bison_FORCE_BUILD)
