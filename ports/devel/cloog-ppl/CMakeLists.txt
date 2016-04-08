
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CLooG)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (CLooG_VERSION        "0.15.9" )
set (CLooG_SOURCE_ARCHIVE "cloog-ppl-${CLooG_VERSION}.tar.gz" )
set (CLooG_URL            "ftp://gcc.gnu.org/pub/gcc/infrastructure/${CLooG_SOURCE_ARCHIVE}" )
set (CLooG_GIT            "git://repo.or.cz/cloog-ppl.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CLooG_FORCE_BUILD    "Force build and installation of package?" NO )
option (CLooG_FROM_REPOS     "Install package from repository?"         NO  )
option (CLooG_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CLooG_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CLooG_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindCLooG)

if (NOT GIT_EXECUTABLE)
  find_program (GIT_EXECUTABLE git
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin)
endif (NOT GIT_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CLooG_FROM_REPOS)
  set (CLooG_FORCE_BUILD TRUE)
endif (CLooG_FROM_REPOS)

if (NOT HAVE_CLooG OR CLooG_FORCE_BUILD)

  ## Locate source file to build from

  find_file (HAVE_CLooG_SOURCE ${CLooG_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT HAVE_CLooG_SOURCE)
    set (HAVE_CLooG_SOURCE ${CLooG_URL})
  endif (NOT HAVE_CLooG_SOURCE)

  ## Build package from source

  if (CLooG_FROM_REPOS)

    ExternalProject_Add (cloog
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${CLooG_GIT}
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --without-polylib --with-gmp=${CMAKE_INSTALL_PREFIX} --with-polylib-prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (CLooG_FROM_REPOS)

    ExternalProject_Add (cloog
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${HAVE_CLooG_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-bits=gmp --with-gmp=${CMAKE_INSTALL_PREFIX} --with-polylib-prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )

  endif (CLooG_FROM_REPOS)

else (NOT HAVE_CLooG OR CLooG_FORCE_BUILD)

  add_custom_target (cloog
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CLooG] Found system-wide installation; skipping rebuild!"
    )

endif (NOT HAVE_CLooG OR CLooG_FORCE_BUILD)
