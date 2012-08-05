
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (A52DEC)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (A52DEC_VERSION        "0.7.4" )
set (A52DEC_SOURCE_ARCHIVE "a52dec-${A52DEC_VERSION}.tar.gz" )
set (A52DEC_URL            "ftp://ftp.videolan.org/pub/videolan/contrib/${A52DEC_SOURCE_ARCHIVE}" )
set (A52DEC_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (A52DEC_FORCE_BUILD    "Force build and installation of package?" NO )
option (A52DEC_FROM_REPOS     "Install package from repository?"         NO )
option (A52DEC_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (A52DEC_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (A52DEC_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (A52DEC)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (A52DEC_FROM_REPOS)
  set (A52DEC_FORCE_BUILD TRUE)
endif (A52DEC_FROM_REPOS)

if (NOT A52DEC_FOUND OR A52DEC_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (A52DEC_SOURCE ${A52DEC_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT A52DEC_SOURCE)
    set (A52DEC_SOURCE ${A52DEC_URL})
  endif (NOT A52DEC_SOURCE)
  
  ## Build package from source
  
  if (A52DEC_FROM_REPOS)
    
    ExternalProject_Add (a52dec
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${A52DEC_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (A52DEC_FROM_REPOS)
    
    ExternalProject_Add (a52dec
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${A52DEC_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (A52DEC_FROM_REPOS)
  
else (NOT A52DEC_FOUND OR A52DEC_FORCE_BUILD)
  
  add_custom_target (a52dec
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[a52dec] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT A52DEC_FOUND OR A52DEC_FORCE_BUILD)
