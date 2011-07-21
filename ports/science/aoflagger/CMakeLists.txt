
## ==============================================================================
##
##  CMake project settings & description
##
##  The RFI software presented here can automatically flag data and can be used
##  to analyze the data in a measurement. The purpose of flagging is to mark
##  samples that are affected by interfering sources such as radio stations, 
##  airplanes, electrical fences or other transmitting interferers.
##  The tools in the package are meant for offline use. The software package
##  contains a graphical interface ("rfigui") that can be used to visualize a
##  measurement set and analyze mitigation techniques. It also contains a console
##  flagger ("rficonsole") that can execute a script of mitigation functions
##  without the overhead of a graphical environment. All tools were written in
##  C++.
##
## ==============================================================================

## Name of the project handled by CMake
project (AOFLAGGER)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (AOFLAGGER_VERSION        "1.3.0" )
set (AOFLAGGER_SOURCE_ARCHIVE "AOFlagger-${AOFLAGGER_VERSION}.tar.bz2" )
set (AOFLAGGER_URL            "http://www.astro.rug.nl/rfi-software/${AOFLAGGER_SOURCE_ARCHIVE}" )
set (AOFLAGGER_SVN            "" )
set (AOFLAGGER_WEBSITE        "http://www.astro.rug.nl/rfi-software")

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (AOFLAGGER_FORCE_BUILD    "Force build and installation of package?" NO )
option (AOFLAGGER_FROM_REPOS     "Install package from repository?"         NO )
option (AOFLAGGER_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (AOFLAGGER_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (AOFLAGGER_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindAOFLAGGER)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (AOFLAGGER_FROM_REPOS)
  set (AOFLAGGER_FORCE_BUILD TRUE)
endif (AOFLAGGER_FROM_REPOS)

if (NOT AOFLAGGER_FOUND OR AOFLAGGER_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (AOFLAGGER_SOURCE ${AOFLAGGER_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT AOFLAGGER_SOURCE)
    set (AOFLAGGER_SOURCE ${AOFLAGGER_URL})
  endif (NOT AOFLAGGER_SOURCE)
  
  ## Build package from source
  
  if (AOFLAGGER_FROM_REPOS)
    
    ExternalProject_Add (aoflagger
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${AOFLAGGER_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (AOFLAGGER_FROM_REPOS)
    
    ExternalProject_Add (aoflagger
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${AOFLAGGER_SOURCE}
      PATH_COMMAND
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (AOFLAGGER_FROM_REPOS)
  
else (NOT AOFLAGGER_FOUND OR AOFLAGGER_FORCE_BUILD)
  
  add_custom_target (aoflagger
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[aoflagger] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT AOFLAGGER_FOUND OR AOFLAGGER_FORCE_BUILD)
