
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Qt)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

## Package information
set (Qt_VERSION        "4.7.3" )
set (Qt_SOURCE_ARCHIVE "qt-everywhere-opensource-src-${Qt_VERSION}.tar.gz" )
set (Qt_URL            "http://get.qt.nokia.com/qt/source/${Qt_SOURCE_ARCHIVE}" )
set (Qt_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Qt_FORCE_BUILD    "Force build and installation of package?" NO  )
option (Qt_FROM_REPOS     "Install package from repository?"         NO  )
option (Qt_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Qt_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Qt_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindQt4)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Qt_FROM_REPOS)
  set (Qt_FORCE_BUILD TRUE)
endif (Qt_FROM_REPOS)

if (NOT QT4_FOUND OR Qt_FORCE_BUILD)

  ## Locate source file to build from

  find_file (Qt_SOURCE ${Qt_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT Qt_SOURCE)
    set (Qt_SOURCE ${Qt_URL})
  endif (NOT Qt_SOURCE)

  ## Build package from source

  ExternalProject_Add (qt
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${Qt_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure -opensource -no-framework -arch "x86 x86_64" --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT QT4_FOUND OR Qt_FORCE_BUILD)

  add_custom_target (qt
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Qt] Found system-wide installation; skipping rebuild!"
    )

endif (NOT QT4_FOUND OR Qt_FORCE_BUILD)
