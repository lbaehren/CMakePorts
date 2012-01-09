
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GUTENPRINT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GUTENPRINT_VERSION_MAJOR  "5" )
set (GUTENPRINT_VERSION_MINOR  "2" )
set (GUTENPRINT_VERSION        "${GUTENPRINT_VERSION_MAJOR}.${GUTENPRINT_VERSION_MINOR}.7" )
set (GUTENPRINT_SOURCE_ARCHIVE "gutenprint-${GUTENPRINT_VERSION}.tar.bz2" )
set (GUTENPRINT_URL            "http://downloads.sourceforge.net/project/gimp-print/gutenprint-5.2/${GUTENPRINT_VERSION}/${GUTENPRINT_SOURCE_ARCHIVE}" )
set (GUTENPRINT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GUTENPRINT_FORCE_BUILD    "Force build and installation of package?" NO )
option (GUTENPRINT_FROM_REPOS     "Install package from repository?"         NO )
option (GUTENPRINT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GUTENPRINT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GUTENPRINT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================


## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GUTENPRINT_FROM_REPOS)
  set (GUTENPRINT_FORCE_BUILD TRUE)
endif (GUTENPRINT_FROM_REPOS)

if (NOT GUTENPRINT_FOUND OR GUTENPRINT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GUTENPRINT_SOURCE ${GUTENPRINT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GUTENPRINT_SOURCE)
    set (GUTENPRINT_SOURCE ${GUTENPRINT_URL})
  endif (NOT GUTENPRINT_SOURCE)
  
  ## Build package from source
  
  if (GUTENPRINT_FROM_REPOS)
    
    ExternalProject_Add (gutenprint
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${GUTENPRINT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (GUTENPRINT_FROM_REPOS)
    
    ExternalProject_Add (gutenprint
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GUTENPRINT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (GUTENPRINT_FROM_REPOS)
  
else (NOT GUTENPRINT_FOUND OR GUTENPRINT_FORCE_BUILD)
  
  add_custom_target (gutenprint
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[gutenprint] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GUTENPRINT_FOUND OR GUTENPRINT_FORCE_BUILD)
