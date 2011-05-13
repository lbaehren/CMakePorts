
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Help2man)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Help2man_VERSION        "1.38.2" )
set (Help2man_SOURCE_ARCHIVE "help2man-${Help2man_VERSION}.tar.gz" )
set (Help2man_URL            "http://ftp.gnu.org/gnu/help2man/${Help2man_SOURCE_ARCHIVE}" )
set (Help2man_MD5            "" )
set (Help2man_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Help2man_FORCE_BUILD    "Force build and installation of package?" NO )
option (Help2man_FROM_REPOS     "Install package from repository?"         NO )
option (Help2man_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Help2man_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Help2man_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (HELP2MAN_EXECUTABLE help2man
  HINTS ${HELP2MAN_ROOT_DIR}
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES bin
  )

if (HELP2MAN_EXECUTABLE)
  set (HELP2MAN_FOUND TRUE)
endif (HELP2MAN_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Help2man_FROM_REPOS)
  set (Help2man_FORCE_BUILD TRUE)
endif (Help2man_FROM_REPOS)

if (NOT HELP2MAN_FOUND OR Help2man_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (Help2man_SOURCE ${Help2man_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT Help2man_SOURCE)
    set (Help2man_SOURCE ${Help2man_URL})
  endif (NOT Help2man_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (help2man
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${Help2man_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT HELP2MAN_FOUND OR Help2man_FORCE_BUILD)
  
  add_custom_target (help2man
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Help2man] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HELP2MAN_FOUND OR Help2man_FORCE_BUILD)
