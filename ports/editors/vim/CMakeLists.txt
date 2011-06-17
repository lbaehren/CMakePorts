
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (VIM)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (VIM_VERSION        "7.3" )
set (VIM_SOURCE_ARCHIVE "vim-${VIM_VERSION}.tar.bz2" )
set (VIM_URL            "ftp://ftp.vim.org/pub/vim/unix/${VIM_SOURCE_ARCHIVE}" )
set (VIM_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (VIM_FORCE_BUILD    "Force build and installation of package?" NO )
option (VIM_FROM_REPOS     "Install package from repository?"         NO )
option (VIM_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (VIM_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (VIM_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindVIM)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (VIM_FROM_REPOS)
  set (VIM_FORCE_BUILD TRUE)
endif (VIM_FROM_REPOS)

if (NOT VIM_FOUND OR VIM_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (VIM_SOURCE ${VIM_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT VIM_SOURCE)
    set (VIM_SOURCE ${VIM_URL})
  endif (NOT VIM_SOURCE)
  
  ## Build package from source
  
  if (VIM_FROM_REPOS)
    
    ExternalProject_Add (vim
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${VIM_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
  
  else (VIM_FROM_REPOS)
    
    ExternalProject_Add (vim
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${VIM_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    
  endif (VIM_FROM_REPOS)
  
else (NOT VIM_FOUND OR VIM_FORCE_BUILD)
  
  add_custom_target (vim
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[vim] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT VIM_FOUND OR VIM_FORCE_BUILD)
