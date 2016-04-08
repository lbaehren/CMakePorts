
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (APR_UTIL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (APR_UTIL_VERSION        "1.3.12" )
set (APR_UTIL_SOURCE_ARCHIVE "apr-util-${APR_UTIL_VERSION}.tar.gz" )
set (APR_UTIL_URL            "http://mirror.checkdomain.de/apache//apr/${APR_UTIL_SOURCE_ARCHIVE}" )
set (APR_UTIL_SVN            "http://svn.apache.org/repos/asf/apr/apr-util/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (APR_UTIL_FORCE_BUILD    "Force build and installation of package?" NO )
option (APR_UTIL_FROM_REPOS     "Install package from repository?"         NO )
option (APR_UTIL_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (APR_UTIL_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (APR_UTIL_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindAPR)

## Extract base directory of APR installation

if (APR_LIBRARIES)
  get_filename_component (APR_LIBRARY_DIR ${APR_LIBRARIES} PATH)
endif (APR_LIBRARIES)

if (APR_LIBRARY_DIR)
  set (APR_PREFIX ${APR_LIBRARY_DIR}/..)
else (APR_LIBRARY_DIR)
  set (APR_PREFIX ${CMAKE_INSTALL_PREFIX})
endif (APR_LIBRARY_DIR)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (APR_UTIL_FROM_REPOS)
  set (APR_UTIL_FORCE_BUILD TRUE)
endif (APR_UTIL_FROM_REPOS)

if (NOT HAVE_APR_UTIL OR APR_UTIL_FORCE_BUILD)

  ## Locate source file to build from

  find_file (APR_UTIL_SOURCE ${APR_UTIL_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT APR_UTIL_SOURCE)
    set (APR_UTIL_SOURCE ${APR_UTIL_URL})
  endif (NOT APR_UTIL_SOURCE)

  ## Build package from source

  ExternalProject_Add (apr-util
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${APR_UTIL_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${APR_PREFIX}
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT HAVE_APR_UTIL OR APR_UTIL_FORCE_BUILD)

  add_custom_target (apr-util
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[APR_UTIL] Found system-wide installation; skipping rebuild!"
    )

endif (NOT HAVE_APR_UTIL OR APR_UTIL_FORCE_BUILD)
