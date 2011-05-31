
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SILO)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SILO_VERSION        "4.8" )
set (SILO_SOURCE_ARCHIVE "silo-${SILO_VERSION}.tar.gz" )
set (SILO_URL            "http://wci.llnl.gov/codes/silo/silo-${SILO_VERSION}/${SILO_SOURCE_ARCHIVE}" )
set (SILO_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SILO_FORCE_BUILD    "Force build and installation of package?" NO )
option (SILO_FROM_REPOS     "Install package from repository?"         NO )
option (SILO_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SILO_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SILO_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindHDF5)
#include (FindSILO)

if (HDF5_FOUND)
  get_filename_component (HDF5_LIBRARY_DIR ${HDF5_HDF5_LIBRARY} PATH)
endif (HDF5_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SILO_FROM_REPOS)
  set (SILO_FORCE_BUILD TRUE)
endif (SILO_FROM_REPOS)

if (NOT SILO_FOUND OR SILO_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SILO_SOURCE ${SILO_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SILO_SOURCE)
    set (SILO_SOURCE ${SILO_URL})
  endif (NOT SILO_SOURCE)
  
  ## Build package from source
  
  if (SILO_FROM_REPOS)
    
    ExternalProject_Add (silo
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SILO_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --with-hdf5=${CMAKE_INSTALL_PREFIX}/include/hdf5,${HDF5_LIBRARY_DIR} --disable-fortran --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (SILO_FROM_REPOS)
    
    ExternalProject_Add (silo
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SILO_SOURCE}
      BUILD_IN_SOURCE 1 
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --with-hdf5=${CMAKE_INSTALL_PREFIX}/include/hdf5,${HDF5_LIBRARY_DIR} --disable-fortran --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (SILO_FROM_REPOS)
  
else (NOT SILO_FOUND OR SILO_FORCE_BUILD)
  
  add_custom_target (silo
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[SILO] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SILO_FOUND OR SILO_FORCE_BUILD)
