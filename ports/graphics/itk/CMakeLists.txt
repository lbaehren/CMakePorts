
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (ITK)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (ITK_VERSION        "" )
set (ITK_SOURCE_ARCHIVE "" )
set (ITK_URL            "" )
set (ITK_GIT            "git://itk.org/ITK.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ITK_FORCE_BUILD    "Force build and installation of package?" NO  )
option (ITK_FROM_REPOS     "Install package from repository?"         YES )
option (ITK_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (ITK_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (ITK_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindITK)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (ITK_FROM_REPOS)
  set (ITK_FORCE_BUILD TRUE)
endif (ITK_FROM_REPOS)

if (NOT ITK_FOUND OR ITK_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (ITK_SOURCE ${ITK_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT ITK_SOURCE)
    set (ITK_SOURCE ${ITK_URL})
  endif (NOT ITK_SOURCE)
  
  ## Build package from source
  
  if (ITK_FROM_REPOS)
    
    ExternalProject_Add (itk
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${ITK_GIT}
      PATCH_COMMAND git submodule update --init
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (ITK_FROM_REPOS)
    
    ExternalProject_Add (itk
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${ITK_SOURCE}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (ITK_FROM_REPOS)
  
else (NOT ITK_FOUND OR ITK_FORCE_BUILD)
  
  add_custom_target (itk
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[itk] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT ITK_FOUND OR ITK_FORCE_BUILD)
