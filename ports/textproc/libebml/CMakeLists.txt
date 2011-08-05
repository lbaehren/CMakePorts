
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBEBML)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBEBML_VERSION        "1.2.0" )
set (LIBEBML_SOURCE_ARCHIVE "libebml-${LIBEBML_VERSION}.tar.bz2" )
set (LIBEBML_URL            "http://dl.matroska.org/downloads/libebml/${LIBEBML_SOURCE_ARCHIVE}" )
set (LIBEBML_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBEBML_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBEBML_FROM_REPOS     "Install package from repository?"         NO )
option (LIBEBML_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBEBML_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBEBML_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindLibembl)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBEBML_FROM_REPOS)
  set (LIBEBML_FORCE_BUILD TRUE)
endif (LIBEBML_FROM_REPOS)

if (NOT LIBEBML_FOUND OR LIBEBML_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBEBML_SOURCE ${LIBEBML_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBEBML_SOURCE)
    set (LIBEBML_SOURCE ${LIBEBML_URL})
  endif (NOT LIBEBML_SOURCE)
  
  ## Build package from source
  
  if (LIBEBML_FROM_REPOS)
    
    ExternalProject_Add (libebml
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBEBML_SVN}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/libebml.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBEBML_FROM_REPOS)
    
    ExternalProject_Add (libebml
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBEBML_SOURCE}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/libebml.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBEBML_FROM_REPOS)
  
else (NOT LIBEBML_FOUND OR LIBEBML_FORCE_BUILD)
  
  add_custom_target (libebml
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libebml] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBEBML_FOUND OR LIBEBML_FORCE_BUILD)
