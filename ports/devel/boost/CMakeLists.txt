
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (BOOST)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (BOOST_VERSION_MAJOR  "1" )
set (BOOST_VERSION_MINOR  "47" )
set (BOOST_VERSION_PATCH  "0" )
set (BOOST_VERSION        "${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_PATCH}" )
set (BOOST_SOURCE_ARCHIVE "boost_${BOOST_VERSION}.tar.bz2" )
set (BOOST_URL            "http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}/${BOOST_SOURCE_ARCHIVE}" )
set (BOOST_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (BOOST_FORCE_BUILD    "Force build and installation of package?" NO )
option (BOOST_FROM_REPOS     "Install package from repository?"         NO )
option (BOOST_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (BOOST_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (BOOST_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_package (Boost)

## Compatibility variables
if (Boost_FOUND)

  set ( BOOST_FOUND     TRUE                  )
  set ( BOOST_INCLUDES  ${Boost_INCLUDE_DIRS} )
  set ( BOOST_LIBRARIES ${Boost_LIBRARIES}    )

endif (Boost_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (BOOST_FROM_REPOS)
  set (BOOST_FORCE_BUILD TRUE)
endif (BOOST_FROM_REPOS)

if (NOT BOOST_FOUND OR BOOST_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (BOOST_SOURCE ${BOOST_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT BOOST_SOURCE)
    set (BOOST_SOURCE ${BOOST_URL})
  endif (NOT BOOST_SOURCE)
  
  ## Build package from source
  
  if (BOOST_FROM_REPOS)
    
    ExternalProject_Add (boost
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${BOOST_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} ./b2 install
      )
  
  else (BOOST_FROM_REPOS)
    
    ExternalProject_Add (boost
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${BOOST_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/bootstrap.sh --prefix=${CMAKE_INSTALL_PREFIX}
      BUILD_COMMAND ./b2
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} ./b2 install
      )
    
  endif (BOOST_FROM_REPOS)
  
else (NOT BOOST_FOUND OR BOOST_FORCE_BUILD)
  
  add_custom_target (boost
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[boost] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT BOOST_FOUND OR BOOST_FORCE_BUILD)
