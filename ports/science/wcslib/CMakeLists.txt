
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (WCSLIB)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (WCSLIB_VERSION        "4.4.4" )
set (WCSLIB_SOURCE_ARCHIVE "wcslib-${WCSLIB_VERSION}.tgz" )
set (WCSLIB_URL            "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib.tar.bz2" )
set (WCSLIB_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (WCSLIB_CMAKE_BUILD "Use CMake to build WCSLIB (experimental)" YES )
option (WCSLIB_FORCE_BUILD "Force build and installation of package?" NO  )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindWCSLIB)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT WCSLIB_FOUND OR WCSLIB_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (WCSLIB_SOURCE ${WCSLIB_SOURCE_ARCHIVE}
    PATHS ${WCSLIB_SOURCE_DIR}
    )
  
  if (NOT WCSLIB_SOURCE)
    set (WCSLIB_SOURCE ${WCSLIB_URL})
  endif (NOT WCSLIB_SOURCE)
  
  ## Build package from source
  
  if (WCSLIB_CMAKE_BUILD)

    ExternalProject_Add (wcslib
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${WCSLIB_SOURCE}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/wcslib.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
    ## copy input for configured header file
    ExternalProject_Add_Step (wcslib wcslib_config
      COMMAND cp ${PROJECT_SOURCE_DIR}/wcsconfig.h.in ${PROJECT_BINARY_DIR}/source/wcsconfig.h.in
      COMMENT "Copying input for configured header file"
      DEPENDEES patch
      DEPENDERS configure
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/source
      )
    
  else (WCSLIB_CMAKE_BUILD)
    
    ExternalProject_Add (wcslib
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${WCSLIB_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (WCSLIB_CMAKE_BUILD)
  
else (NOT WCSLIB_FOUND OR WCSLIB_FORCE_BUILD)
  
  add_custom_target (wcslib
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[WCSLIB] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT WCSLIB_FOUND OR WCSLIB_FORCE_BUILD)
