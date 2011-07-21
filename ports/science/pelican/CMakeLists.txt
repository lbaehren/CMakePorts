
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (PELICAN)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (PELICAN_VERSION        "" )
set (PELICAN_SOURCE_ARCHIVE "pelican.tgz" )
set (PELICAN_URL            "" )
set (PELICAN_GIT            "git://github.com/pelican/pelican.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (PELICAN_FORCE_BUILD    "Force build and installation of package?" NO  )
option (PELICAN_FROM_REPOS     "Install package from repository?"         YES )
option (PELICAN_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (PELICAN_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (PELICAN_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindPELICAN)
include (FindCppUnit)
include (FindQt4)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (PELICAN_FROM_REPOS)
  set (PELICAN_FORCE_BUILD TRUE)
endif (PELICAN_FROM_REPOS)

if (NOT PELICAN_FOUND OR PELICAN_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (PELICAN_SOURCE ${PELICAN_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT PELICAN_SOURCE)
    set (PELICAN_SOURCE ${PELICAN_URL})
  endif (NOT PELICAN_SOURCE)
  
  ## Build package from source
  
  if (PELICAN_FROM_REPOS)
    
    ExternalProject_Add (pelican
      PREFIX ${PROJECT_BINARY_DIR}
      GIT_REPOSITORY ${PELICAN_GIT}
      CONFIGURE_COMMAND cmake -DCPPUNIT_INCLUDE_DIR=${CPPUNIT_INCLUDES} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${PROJECT_BINARY_DIR}/src/pelican/pelican
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (PELICAN_FROM_REPOS)
    
    ExternalProject_Add (pelican
      PREFIX ${PROJECT_BINARY_DIR}
      URL ${PELICAN_SOURCE}
      CMAKE_CACHE_ARGS -DCPPUNIT_INCLUDE_DIR:PATH=${CPPUNIT_INCLUDES} -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (PELICAN_FROM_REPOS)
  
else (NOT PELICAN_FOUND OR PELICAN_FORCE_BUILD)
  
  add_custom_target (pelican
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[PELICAN] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT PELICAN_FOUND OR PELICAN_FORCE_BUILD)
