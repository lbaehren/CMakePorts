
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (FREETYPE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (FREETYPE_VERSION        "2.4.10" )
set (FREETYPE_SOURCE_ARCHIVE "freetype-${FREETYPE_VERSION}.tar.gz" )
set (FREETYPE_URL            "http://downloads.sourceforge.net/project/freetype/freetype2/${FREETYPE_VERSION}/${FREETYPE_SOURCE_ARCHIVE}" )
set (FREETYPE_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (FREETYPE_FORCE_BUILD    "Force build and installation of package?" NO )
option (FREETYPE_FROM_REPOS     "Install package from repository?"         NO )
option (FREETYPE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (FREETYPE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (FREETYPE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

# find_package (FREETYPE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (FREETYPE_FROM_REPOS)
  set (FREETYPE_FORCE_BUILD TRUE)
endif (FREETYPE_FROM_REPOS)

if (NOT FREETYPE_FOUND OR FREETYPE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (FREETYPE_SOURCE ${FREETYPE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT FREETYPE_SOURCE)
    set (FREETYPE_SOURCE ${FREETYPE_URL})
  endif (NOT FREETYPE_SOURCE)
  
  ## Build package from source
  
  if (FREETYPE_FROM_REPOS)
    
    ExternalProject_Add (freetype
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${FREETYPE_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (FREETYPE_FROM_REPOS)
    
    ExternalProject_Add (freetype
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${FREETYPE_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (FREETYPE_FROM_REPOS)
  
else (NOT FREETYPE_FOUND OR FREETYPE_FORCE_BUILD)
  
  add_custom_target (freetype
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[freetype] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT FREETYPE_FOUND OR FREETYPE_FORCE_BUILD)
