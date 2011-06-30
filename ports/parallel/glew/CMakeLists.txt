
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GLEW)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GLEW_VERSION        "1.6.0" )
set (GLEW_SOURCE_ARCHIVE "glew-${GLEW_VERSION}.tgz" )
set (GLEW_URL            "http://downloads.sourceforge.net/project/glew/glew/${GLEW_VERSION}/${GLEW_SOURCE_ARCHIVE}" )
set (GLEW_GIT            "git://glew.git.sourceforge.net/gitroot/glew/glew" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GLEW_FORCE_BUILD    "Force build and installation of package?" NO )
option (GLEW_FROM_REPOS     "Install package from repository?"         NO )
option (GLEW_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GLEW_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GLEW_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGLEW)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GLEW_FROM_REPOS)
  set (GLEW_FORCE_BUILD TRUE)
endif (GLEW_FROM_REPOS)

if (NOT GLEW_FOUND OR GLEW_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GLEW_SOURCE ${GLEW_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GLEW_SOURCE)
    set (GLEW_SOURCE ${GLEW_URL})
  endif (NOT GLEW_SOURCE)
  
  ## Build package from source
  
  if (GLEW_FROM_REPOS)
    
    ExternalProject_Add (glew
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${GLEW_GIT}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (GLEW_FROM_REPOS)
    
    ExternalProject_Add (glew
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GLEW_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (GLEW_FROM_REPOS)
  
else (NOT GLEW_FOUND OR GLEW_FORCE_BUILD)
  
  add_custom_target (glew
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[glew] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GLEW_FOUND OR GLEW_FORCE_BUILD)
