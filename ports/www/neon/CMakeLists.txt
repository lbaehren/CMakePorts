
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Neon)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Neon_VERSION        "0.29.6" )
set (Neon_SOURCE_ARCHIVE "neon-${Neon_VERSION}.tar.gz" )
set (Neon_URL            "http://www.webdav.org/neon/${Neon_SOURCE_ARCHIVE}" )
set (Neon_MD5            "" )
set (Neon_SVN            "http://svn.webdav.org/repos/projects/neon" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Neon_FORCE_BUILD    "Force build and installation of package?" NO )
option (Neon_FROM_REPOS     "Install package from repository?"         NO )
option (Neon_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Neon_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Neon_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindNeon)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Neon_FROM_REPOS)
  set (Neon_FORCE_BUILD TRUE)
endif (Neon_FROM_REPOS)

if (NOT HAVE_Neon OR Neon_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (Neon_SOURCE ${Neon_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT Neon_SOURCE)
    set (Neon_SOURCE ${Neon_URL})
  endif (NOT Neon_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (neon
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${Neon_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-ssl
    INSTALL_COMMAND sudo make install
    )
  
else (NOT HAVE_Neon OR Neon_FORCE_BUILD)
  
  add_custom_target (neon
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Neon] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_Neon OR Neon_FORCE_BUILD)
