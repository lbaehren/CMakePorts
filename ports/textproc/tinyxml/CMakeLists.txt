
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TINYXML)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (TINYXML_VERSION_MAJOR  "2" )
set (TINYXML_VERSION_MINOR  "6" )
set (TINYXML_VERSION_PATCH  "2" )
set (TINYXML_VERSION        "${TINYXML_VERSION_MAJOR}.${TINYXML_VERSION_MINOR}.${TINYXML_VERSION_PATCH}" )
set (TINYXML_SOURCE_ARCHIVE "tinyxml_${TINYXML_VERSION_MAJOR}_${TINYXML_VERSION_MINOR}_${TINYXML_VERSION_PATCH}.zip" )
set (TINYXML_URL            "http://downloads.sourceforge.net/project/tinyxml/tinyxml/${TINYXML_VERSION}/${TINYXML_SOURCE_ARCHIVE}" )
set (TINYXML_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (TINYXML_FORCE_BUILD    "Force build and installation of package?" NO )
option (TINYXML_FROM_REPOS     "Install package from repository?"         NO )
option (TINYXML_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (TINYXML_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (TINYXML_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindTINYXML)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (TINYXML_FROM_REPOS)
  set (TINYXML_FORCE_BUILD TRUE)
endif (TINYXML_FROM_REPOS)

if (NOT TINYXML_FOUND OR TINYXML_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (TINYXML_SOURCE ${TINYXML_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT TINYXML_SOURCE)
    set (TINYXML_SOURCE ${TINYXML_URL})
  endif (NOT TINYXML_SOURCE)
  
  ## Build package from source
  
  if (TINYXML_FROM_REPOS)
    
    ExternalProject_Add (tinyxml
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${TINYXML_SVN}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/tinyxml.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (TINYXML_FROM_REPOS)
    
    ExternalProject_Add (tinyxml
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${TINYXML_SOURCE}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/tinyxml.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (TINYXML_FROM_REPOS)
  
else (NOT TINYXML_FOUND OR TINYXML_FORCE_BUILD)
  
  add_custom_target (tinyxml
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[TinyXML] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT TINYXML_FOUND OR TINYXML_FORCE_BUILD)
