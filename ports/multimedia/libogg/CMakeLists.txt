
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBOGG)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBOGG_VERSION        "1.2.2" )
set (LIBOGG_SOURCE_ARCHIVE "libogg-${LIBOGG_VERSION}.tar.gz" )
set (LIBOGG_URL            "ftp://ftp.videolan.org/pub/videolan/contrib/${LIBOGG_SOURCE_ARCHIVE}" )
set (LIBOGG_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBOGG_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBOGG_FROM_REPOS     "Install package from repository?"         NO )
option (LIBOGG_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBOGG_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBOGG_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (LibOgg)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBOGG_FROM_REPOS)
  set (LIBOGG_FORCE_BUILD TRUE)
endif (LIBOGG_FROM_REPOS)

if (NOT LIBOGG_FOUND OR LIBOGG_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBOGG_SOURCE ${LIBOGG_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBOGG_SOURCE)
    set (LIBOGG_SOURCE ${LIBOGG_URL})
  endif (NOT LIBOGG_SOURCE)
  
  ## Build package from source
  
  if (LIBOGG_FROM_REPOS)
    
    ExternalProject_Add (libogg
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBOGG_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBOGG_FROM_REPOS)
    
    ExternalProject_Add (libogg
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBOGG_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBOGG_FROM_REPOS)
  
else (NOT LIBOGG_FOUND OR LIBOGG_FORCE_BUILD)
  
  add_custom_target (libogg
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libogg] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBOGG_FOUND OR LIBOGG_FORCE_BUILD)
