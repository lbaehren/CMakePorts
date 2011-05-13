
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CPPUNIT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (CPPUNIT_VERSION        "1.10.0" )
set (CPPUNIT_SOURCE_ARCHIVE "cppunit-${CPPUNIT_VERSION}.tar.gz" )
set (CPPUNIT_URL            "http://sourceforge.net/projects/cppunit/files/cppunit/${CPPUNIT_VERSION}/${CPPUNIT_SOURCE_ARCHIVE}/download" )
set (CPPUNIT_SVN            "https://cppunit.svn.sourceforge.net/svnroot/cppunit/trunk/cppunit" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CPPUNIT_FORCE_BUILD    "Force build and installation of package?" NO )
option (CPPUNIT_FROM_REPOS     "Install package from repository?"         NO )
option (CPPUNIT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CPPUNIT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CPPUNIT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindCppUnit)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CPPUNIT_FROM_REPOS)
  set (CPPUNIT_FORCE_BUILD TRUE)
endif (CPPUNIT_FROM_REPOS)

if (NOT CPPUNIT_FOUND OR CPPUNIT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (CPPUNIT_SOURCE ${CPPUNIT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT CPPUNIT_SOURCE)
    set (CPPUNIT_SOURCE ${CPPUNIT_URL})
  endif (NOT CPPUNIT_SOURCE)
  
  ## Build package from source
  
  if (CPPUNIT_FROM_REPOS)
    
    ExternalProject_Add (cppunit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${CPPUNIT_SVN}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (CPPUNIT_FROM_REPOS)
    
    ExternalProject_Add (cppunit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${CPPUNIT_SOURCE}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/autogen.sh
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (CPPUNIT_FROM_REPOS)
  
else (NOT CPPUNIT_FOUND OR CPPUNIT_FORCE_BUILD)
  
  add_custom_target (cppunit
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CPPUNIT] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CPPUNIT_FOUND OR CPPUNIT_FORCE_BUILD)
