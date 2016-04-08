
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (MPFR)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (MPFR_VERSION        "2.4.2" )
set (MPFR_SOURCE_ARCHIVE "mpfr-${MPFR_VERSION}.tar.gz" )
set (MPFR_URL            "http://mpfr.loria.fr/mpfr-${MPFR_VERSION}/${MPFR_SOURCE_ARCHIVE}" )
set (MPFR_MD5            "" )
set (MPFR_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (MPFR_FORCE_BUILD    "Force build and installation of package?" NO  )
option (MPFR_FROM_REPOS     "Install package from repository?"         NO  )
option (MPFR_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (MPFR_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (MPFR_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

if (NOT GMP_FOUND)
  set (GMP_FIND_QUIETLY  YES)
  include (FindGMP)
endif (NOT GMP_FOUND)

if (NOT MPFR_FOUND)
  set (MPFR_FIND_QUIETLY YES)
  include (FindMPFR)
endif (NOT MPFR_FOUND)

if (GMP_GMP_LIBRARY)
  get_filename_component (GMP_GMP_LIBRARY ${GMP_GMP_LIBRARY} PATH)
endif (GMP_GMP_LIBRARY)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (MPFR_FROM_REPOS)
  set (MPFR_FORCE_BUILD TRUE)
endif (MPFR_FROM_REPOS)

if (NOT MPFR_FOUND OR MPFR_FORCE_BUILD)

  ## Locate source file to build from

  find_file (MPFR_SOURCE ${MPFR_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT MPFR_SOURCE)
    set (MPFR_SOURCE ${MPFR_URL})
  endif (NOT MPFR_SOURCE)

  ## Build package from source

  ExternalProject_Add (mpfr
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${MPFR_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-gmp-include=${CMAKE_INSTALL_PREFIX}/include --with-gmp-lib=${CMAKE_INSTALL_PREFIX}/lib
    INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
    )

else (NOT MPFR_FOUND OR MPFR_FORCE_BUILD)

  add_custom_target (mpfr
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[MPFR] Found system-wide installation; skipping rebuild!"
    )

endif (NOT MPFR_FOUND OR MPFR_FORCE_BUILD)
