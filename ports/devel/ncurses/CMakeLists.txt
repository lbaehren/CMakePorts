
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (NCURSES)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (NCURSES_VERSION        "5.7" )
set (NCURSES_SOURCE_ARCHIVE "ncurses-${NCURSES_VERSION}.tar.gz" )
set (NCURSES_URL            "http://ftp.gnu.org/pub/gnu/ncurses/${NCURSES_SOURCE_ARCHIVE}" )
set (NCURSES_MD5            "" )
set (NCURSES_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (NCURSES_FORCE_BUILD    "Force build and installation of package?" NO )
option (NCURSES_FROM_REPOS     "Install package from repository?"         NO )
option (NCURSES_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (NCURSES_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (NCURSES_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindCurses)

if (CURSES_FOUND)
  set (NCURSES_FOUND TRUE)
endif (CURSES_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NCURSES_FROM_REPOS)
  set (NCURSES_FORCE_BUILD TRUE)
endif (NCURSES_FROM_REPOS)

if (NOT NCURSES_FOUND OR NCURSES_FORCE_BUILD)

  ## Locate source file to build from

  find_file (NCURSES_SOURCE ${NCURSES_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT NCURSES_SOURCE)
    set (NCURSES_SOURCE ${NCURSES_URL})
  endif (NOT NCURSES_SOURCE)

  ## Build package from source

  ExternalProject_Add (ncurses
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${NCURSES_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT NCURSES_FOUND OR NCURSES_FORCE_BUILD)

  add_custom_target (ncurses
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[ncurses] Found system-wide installation; skipping rebuild!"
    )

endif (NOT NCURSES_FOUND OR NCURSES_FORCE_BUILD)
