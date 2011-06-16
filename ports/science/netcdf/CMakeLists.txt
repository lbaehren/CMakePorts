
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (NETCDF)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (NETCDF_VERSION        "4.1.1" )
set (NETCDF_SOURCE_ARCHIVE "netcdf-${NETCDF_VERSION}.tar.gz" )
set (NETCDF_URL            "http://www.unidata.ucar.edu/downloads/netcdf/ftp/${NETCDF_SOURCE_ARCHIVE}" )
set (NETCDF_MD5            "" )
set (NETCDF_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (NETCDF_FORCE_BUILD    "Force build and installation of package?" NO )
option (NETCDF_FROM_REPOS     "Install package from repository?"         NO )
option (NETCDF_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (NETCDF_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (NETCDF_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindNetCDF)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NETCDF_FROM_REPOS)
  set (NETCDF_FORCE_BUILD TRUE)
endif (NETCDF_FROM_REPOS)

if (NOT NETCDF_FOUND OR NETCDF_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (NETCDF_SOURCE ${NETCDF_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT NETCDF_SOURCE)
    set (NETCDF_SOURCE ${NETCDF_URL})
  endif (NOT NETCDF_SOURCE)
  
  ## Build package from source
  
  if (NETCDF_FROM_REPOS)
    
    ExternalProject_Add (netcdf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${NETCDF_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --disable-f77
      INSTALL_COMMAND sudo make install
      )
  
  else (NETCDF_FROM_REPOS)
    
    ExternalProject_Add (netcdf
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${NETCDF_SOURCE}
      URL_MD5 ${NETCDF_MD5}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --disable-f77
      INSTALL_COMMAND sudo make install
      )
    
  endif (NETCDF_FROM_REPOS)
  
else (NOT NETCDF_FOUND OR NETCDF_FORCE_BUILD)
  
  add_custom_target (netcdf
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[NetCDF] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT NETCDF_FOUND OR NETCDF_FORCE_BUILD)
