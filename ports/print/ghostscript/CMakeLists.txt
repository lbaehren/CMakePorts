
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GHOSTSCRIPT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GHOSTSCRIPT_VERSION        "9.02" )
set (GHOSTSCRIPT_SOURCE_ARCHIVE "ghostscript-${GHOSTSCRIPT_VERSION}.tar.gz" )
set (GHOSTSCRIPT_URL            "http://downloads.ghostscript.com/public/${GHOSTSCRIPT_SOURCE_ARCHIVE}" )
set (GHOSTSCRIPT_GIT            "git://git.ghostscript.com/web/wisc.edu.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GHOSTSCRIPT_FORCE_BUILD    "Force build and installation of package?" NO )
option (GHOSTSCRIPT_FROM_REPOS     "Install package from repository?"         NO )
option (GHOSTSCRIPT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GHOSTSCRIPT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GHOSTSCRIPT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGhostscript)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GHOSTSCRIPT_FROM_REPOS)
  set (GHOSTSCRIPT_FORCE_BUILD TRUE)
endif (GHOSTSCRIPT_FROM_REPOS)

if (NOT GHOSTSCRIPT_FOUND OR GHOSTSCRIPT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GHOSTSCRIPT_SOURCE ${GHOSTSCRIPT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GHOSTSCRIPT_SOURCE)
    set (GHOSTSCRIPT_SOURCE ${GHOSTSCRIPT_URL})
  endif (NOT GHOSTSCRIPT_SOURCE)
  
  ## Build package from source
  
  if (GHOSTSCRIPT_FROM_REPOS)
    
    ExternalProject_Add (ghostscript
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${GHOSTSCRIPT_GIT}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (GHOSTSCRIPT_FROM_REPOS)
    
    ExternalProject_Add (ghostscript
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GHOSTSCRIPT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (GHOSTSCRIPT_FROM_REPOS)
  
else (NOT GHOSTSCRIPT_FOUND OR GHOSTSCRIPT_FORCE_BUILD)
  
  add_custom_target (ghostscript
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Ghostscript] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GHOSTSCRIPT_FOUND OR GHOSTSCRIPT_FORCE_BUILD)
