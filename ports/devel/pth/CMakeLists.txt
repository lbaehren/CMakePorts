
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PTH)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (PTH_VERSION        "2.0.7" )
set (PTH_SOURCE_ARCHIVE "pth-${PTH_VERSION}.tar.gz" )
set (PTH_URL            "ftp://ftp.gnu.org/gnu/pth/${PTH_SOURCE_ARCHIVE}" )
set (PTH_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PTH_FORCE_BUILD    "Force build and installation of package?" NO )
option (PTH_FROM_REPOS     "Install package from repository?"         NO )
option (PTH_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (PTH_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (PTH_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindPth)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (PTH_FROM_REPOS)
  set (PTH_FORCE_BUILD TRUE)
endif (PTH_FROM_REPOS)

if (NOT PTH_FOUND OR PTH_FORCE_BUILD)

  ## Locate source file to build from

  find_file (PTH_SOURCE ${PTH_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT PTH_SOURCE)
    set (PTH_SOURCE ${PTH_URL})
  endif (NOT PTH_SOURCE)

  ## Build package from source

  if (PTH_FROM_REPOS)

    ExternalProject_Add (pth
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${PTH_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (PTH_FROM_REPOS)

    ExternalProject_Add (pth
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${PTH_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  endif (PTH_FROM_REPOS)

else (NOT PTH_FOUND OR PTH_FORCE_BUILD)

  add_custom_target (pth
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[PTH] Found system-wide installation; skipping rebuild!"
    )

endif (NOT PTH_FOUND OR PTH_FORCE_BUILD)
