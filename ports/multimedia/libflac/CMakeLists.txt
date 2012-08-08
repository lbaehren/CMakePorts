## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBFLAC)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBFLAC_VERSION        "1.2.1" )
set (LIBFLAC_SOURCE_ARCHIVE "flac-${LIBFLAC_VERSION}.tar.gz" )
set (LIBFLAC_URL            "http://downloads.xiph.org/releases/flac/${LIBFLAC_SOURCE_ARCHIVE}" )
set (LIBFLAC_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBFLAC_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBFLAC_FROM_REPOS     "Install package from repository?"         NO )
option (LIBFLAC_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBFLAC_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBFLAC_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (LibFlac)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBFLAC_FROM_REPOS)
  set (LIBFLAC_FORCE_BUILD TRUE)
endif (LIBFLAC_FROM_REPOS)

if (NOT LIBFLAC_FOUND OR LIBFLAC_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBFLAC_SOURCE ${LIBFLAC_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBFLAC_SOURCE)
    set (LIBFLAC_SOURCE ${LIBFLAC_URL})
  endif (NOT LIBFLAC_SOURCE)
  
  ## Build package from source
  
  if (LIBFLAC_FROM_REPOS)
    
    ExternalProject_Add (libflac
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBFLAC_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBFLAC_FROM_REPOS)
    
    ExternalProject_Add (libflac
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBFLAC_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBFLAC_FROM_REPOS)
  
else (NOT LIBFLAC_FOUND OR LIBFLAC_FORCE_BUILD)
  
  add_custom_target (libflac
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libflac] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBFLAC_FOUND OR LIBFLAC_FORCE_BUILD)
