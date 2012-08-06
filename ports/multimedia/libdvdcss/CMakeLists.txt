
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBDVDCSS)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBDVDCSS_VERSION        "1.2.12" )
set (LIBDVDCSS_SOURCE_ARCHIVE "libdvdcss-${LIBDVDCSS_VERSION}.tar.bz2" )
set (LIBDVDCSS_URL            "http://download.videolan.org/pub/libdvdcss/${LIBDVDCSS_VERSION}/${LIBDVDCSS_SOURCE_ARCHIVE}" )
set (LIBDVDCSS_SVN            "svn://svn.videolan.org/libdvdcss/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBDVDCSS_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBDVDCSS_FROM_REPOS     "Install package from repository?"         NO )
option (LIBDVDCSS_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBDVDCSS_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBDVDCSS_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (LIBDVDCSS)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBDVDCSS_FROM_REPOS)
  set (LIBDVDCSS_FORCE_BUILD TRUE)
endif (LIBDVDCSS_FROM_REPOS)

if (NOT LIBDVDCSS_FOUND OR LIBDVDCSS_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBDVDCSS_SOURCE ${LIBDVDCSS_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBDVDCSS_SOURCE)
    set (LIBDVDCSS_SOURCE ${LIBDVDCSS_URL})
  endif (NOT LIBDVDCSS_SOURCE)
  
  ## Build package from source
  
  if (LIBDVDCSS_FROM_REPOS)
    
    ExternalProject_Add (libdvdcss
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBDVDCSS_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBDVDCSS_FROM_REPOS)
    
    ExternalProject_Add (libdvdcss
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBDVDCSS_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBDVDCSS_FROM_REPOS)
  
else (NOT LIBDVDCSS_FOUND OR LIBDVDCSS_FORCE_BUILD)
  
  add_custom_target (libdvdcss
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libdvdcss] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBDVDCSS_FOUND OR LIBDVDCSS_FORCE_BUILD)
