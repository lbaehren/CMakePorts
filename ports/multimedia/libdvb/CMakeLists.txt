
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBDVB)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBDVB_VERSION        "0.5.0" )
set (LIBDVB_SOURCE_ARCHIVE "libdvb-${LIBDVB_VERSION}.tar.gz" )
set (LIBDVB_URL            "ftp://ftp.videolan.org/pub/videolan/contrib/${LIBDVB_SOURCE_ARCHIVE}" )
set (LIBDVB_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBDVB_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBDVB_FROM_REPOS     "Install package from repository?"         NO )
option (LIBDVB_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBDVB_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBDVB_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_package (LibDvb)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBDVB_FROM_REPOS)
  set (LIBDVB_FORCE_BUILD TRUE)
endif (LIBDVB_FROM_REPOS)

if (NOT LIBDVB_FOUND OR LIBDVB_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBDVB_SOURCE ${LIBDVB_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBDVB_SOURCE)
    set (LIBDVB_SOURCE ${LIBDVB_URL})
  endif (NOT LIBDVB_SOURCE)
  
  ## Build package from source
  
  if (LIBDVB_FROM_REPOS)
    
    ExternalProject_Add (libdvb
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBDVB_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBDVB_FROM_REPOS)
    
    ExternalProject_Add (libdvb
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBDVB_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBDVB_FROM_REPOS)
  
else (NOT LIBDVB_FOUND OR LIBDVB_FORCE_BUILD)
  
  add_custom_target (libdvb
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libdvb] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBDVB_FOUND OR LIBDVB_FORCE_BUILD)
