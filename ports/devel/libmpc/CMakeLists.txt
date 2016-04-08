
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (MPC)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (MPC_VERSION        "0.8.1" )
set (MPC_SOURCE_ARCHIVE "mpc-${MPC_VERSION}.tar.gz" )
set (MPC_URL            "ftp://ftp.nluug.nl/mirror/languages/gcc/infrastructure/${MPC_SOURCE_ARCHIVE}" )
set (MPC_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (MPC_FORCE_BUILD    "Force build and installation of package?" NO )
option (MPC_FROM_REPOS     "Install package from repository?"         NO )
option (MPC_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (MPC_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (MPC_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGMP)
include (FindMPC)
include (FindMPFR)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (MPC_FROM_REPOS)
  set (MPC_FORCE_BUILD TRUE)
endif (MPC_FROM_REPOS)

if (NOT MPC_FOUND OR MPC_FORCE_BUILD)

  ## Locate source file to build from

  find_file (MPC_SOURCE ${MPC_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT MPC_SOURCE)
    set (MPC_SOURCE ${MPC_URL})
  endif (NOT MPC_SOURCE)

  ## Build package from source

  ExternalProject_Add (libmpc
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${MPC_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --disable-shared --with-gmp-include=${CMAKE_INSTALL_PREFIX}/include --with-gmp-lib=${CMAKE_INSTALL_PREFIX}/lib --with-mpfr-include=${CMAKE_INSTALL_PREFIX}/include --with-mpfr-lib=${CMAKE_INSTALL_PREFIX}/lib
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT MPC_FOUND OR MPC_FORCE_BUILD)

  add_custom_target (libmpc
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[MPC] Found system-wide installation; skipping rebuild!"
    )

endif (NOT MPC_FOUND OR MPC_FORCE_BUILD)
