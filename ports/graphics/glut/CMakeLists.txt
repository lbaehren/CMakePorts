
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GLUT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GLUT_VERSION        "3.7" )
set (GLUT_SOURCE_ARCHIVE "glut-${GLUT_VERSION}.tar.gz" )
set (GLUT_URL            "http://www.opengl.org/resources/libraries/glut/${GLUT_SOURCE_ARCHIVE}" )
set (GLUT_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GLUT_FORCE_BUILD    "Force build and installation of package?" NO )
option (GLUT_FROM_REPOS     "Install package from repository?"         NO )
option (GLUT_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (GLUT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GLUT_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGLUT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GLUT_FROM_REPOS)
  set (GLUT_FORCE_BUILD TRUE)
endif (GLUT_FROM_REPOS)

if (NOT GLUT_FOUND OR GLUT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GLUT_SOURCE ${GLUT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GLUT_SOURCE)
    set (GLUT_SOURCE ${GLUT_URL})
  endif (NOT GLUT_SOURCE)
  
  ## Build package from source
  
  if (GLUT_FROM_REPOS)
    
    ExternalProject_Add (glut
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${GLUT_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (GLUT_FROM_REPOS)
    
    ExternalProject_Add (glut
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GLUT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (GLUT_FROM_REPOS)
  
else (NOT GLUT_FOUND OR GLUT_FORCE_BUILD)
  
  add_custom_target (glut
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[glut] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GLUT_FOUND OR GLUT_FORCE_BUILD)
