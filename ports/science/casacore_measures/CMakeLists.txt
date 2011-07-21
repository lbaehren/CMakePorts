
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CASACORE_MEASURES)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (CASACORE_MEASURES_VERSION        "" )
set (CASACORE_MEASURES_SOURCE_ARCHIVE "asap_data.tar.bz2" )
set (CASACORE_MEASURES_URL            "ftp://ftp.atnf.csiro.au/pub/software/asap/data/${CASACORE_MEASURES_SOURCE_ARCHIVE}" )
set (CASACORE_MEASURES_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CASACORE_MEASURES_FORCE_BUILD    "Force build and installation of package?" NO )
option (CASACORE_MEASURES_FROM_REPOS     "Install package from repository?"         NO )
option (CASACORE_MEASURES_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CASACORE_MEASURES_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CASACORE_MEASURES_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_path (CASACORE_DATADIR ephemerides
  HINTS ${CASACORE_ROOT_DIR}
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES share/casacore share/casacore/data
  )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CASACORE_MEASURES_FROM_REPOS)
  set (CASACORE_MEASURES_FORCE_BUILD TRUE)
endif (CASACORE_MEASURES_FROM_REPOS)

if (NOT CASACORE_MEASURES_FOUND OR CASACORE_MEASURES_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (CASACORE_MEASURES_SOURCE ${CASACORE_MEASURES_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT CASACORE_MEASURES_SOURCE)
    set (CASACORE_MEASURES_SOURCE ${CASACORE_MEASURES_URL})
  endif (NOT CASACORE_MEASURES_SOURCE)
  
  ## Build package from source
  
  if (CASACORE_MEASURES_FROM_REPOS)
    
    ExternalProject_Add (casacore_measures
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${CASACORE_MEASURES_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND 
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (CASACORE_MEASURES_FROM_REPOS)
    
    ExternalProject_Add (casacore_measures
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${CASACORE_MEASURES_SOURCE}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/casacore_measures.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (CASACORE_MEASURES_FROM_REPOS)
  
else (NOT CASACORE_MEASURES_FOUND OR CASACORE_MEASURES_FORCE_BUILD)
  
  add_custom_target (casacore_measures
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[casacore_measures] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CASACORE_MEASURES_FOUND OR CASACORE_MEASURES_FORCE_BUILD)
