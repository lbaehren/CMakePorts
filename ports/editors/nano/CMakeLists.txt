
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (NANO)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (NANO_VERSION        "2.3.1" )
set (NANO_SOURCE_ARCHIVE "nano-${NANO_VERSION}.tar.gz" )
set (NANO_URL            "http://ftp.gnu.org/gnu/nano/${NANO_SOURCE_ARCHIVE}" )
set (NANO_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (NANO_FORCE_BUILD    "Force build and installation of package?" NO )
option (NANO_FROM_REPOS     "Install package from repository?"         NO )
option (NANO_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (NANO_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (NANO_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (NANO_EXECUTABLE nano
  HINTS ${NANO_ROOT_DIR} ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin local/bin
  )

if (NANO_EXECUTABLE)
  set (NANO_FOUND TRUE)
else (NANO_EXECUTABLE)
  set (NANO_FOUND FALSE)
endif (NANO_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NANO_FROM_REPOS)
  set (NANO_FORCE_BUILD TRUE)
endif (NANO_FROM_REPOS)

if (NOT NANO_FOUND OR NANO_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (NANO_SOURCE ${NANO_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT NANO_SOURCE)
    set (NANO_SOURCE ${NANO_URL})
  endif (NOT NANO_SOURCE)
  
  ## Build package from source
  
  if (NANO_FROM_REPOS)
    
    ExternalProject_Add (nano
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${NANO_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (NANO_FROM_REPOS)
    
    ExternalProject_Add (nano
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${NANO_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (NANO_FROM_REPOS)
  
else (NOT NANO_FOUND OR NANO_FORCE_BUILD)
  
  add_custom_target (nano
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[nano] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT NANO_FOUND OR NANO_FORCE_BUILD)
