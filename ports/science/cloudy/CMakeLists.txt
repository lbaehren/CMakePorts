
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CLOUDY)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (CLOUDY_VERSION        "08.01" )
set (CLOUDY_SOURCE_ARCHIVE "c${CLOUDY_VERSION}.tar.gz" )
set (CLOUDY_URL            "http://viewvc.nublado.org/index.cgi/tags/release/${CLOUDY_SOURCE_ARCHIVE}?root=cloudy&view=tar" )
set (CLOUDY_MD5            "" )
set (CLOUDY_SVN            "http://svn.nublado.org/cloudy/tags/release/c08.01" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CLOUDY_FORCE_BUILD    "Force build and installation of package?" NO  )
option (CLOUDY_FROM_REPOS     "Install package from repository?"         YES )
option (CLOUDY_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CLOUDY_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CLOUDY_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindCLOUDY)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

#
# Organization of the source code:
#
#  .
#  ├── data
#  ├── docs
#  ├── doxygen
#  ├── source                 .. source code to build library
#  │   ├── sys_IBMxSeries
#  │   ├── sys_gcc
#  │   ├── sys_gcc_shared
#  │   ├── sys_gprof
#  │   ├── sys_icc
#  │   ├── sys_open64
#  │   ├── sys_pgcc
#  │   ├── sys_pgccBounds
#  │   └── sys_solstudio
#  └── tsuite
#      ├── auto
#      ├── crash
#      ├── programs
#      │   ├── collion
#      │   ├── comp4
#      │   ├── hazy_coolingcurve
#      │   ├── hazy_kmt
#      │   ├── hizlte
#      │   ├── mpi
#      │   ├── vary_nete
#      │   └── varyn
#      └── slow
#

if (CLOUDY_FROM_REPOS)
  set (CLOUDY_FORCE_BUILD TRUE)
endif (CLOUDY_FROM_REPOS)

if (NOT CLOUDY_FOUND OR CLOUDY_FORCE_BUILD)

  if (CLOUDY_FROM_REPOS)
    
    ExternalProject_Add (cloudy
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${CLOUDY_SVN}
      PATCH_COMMAND cp ${PROJECT_SOURCE_DIR}/cloudy.cmake ${PROJECT_BINARY_DIR}/source/CMakeLists.txt
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${PROJECT_BINARY_DIR}/source
      INSTALL_COMMAND sudo make install
      )
    
  else (CLOUDY_FROM_REPOS)
    
    ## Locate source file to build from
    
    find_file (CLOUDY_SOURCE ${CLOUDY_SOURCE_ARCHIVE}
      PATHS ${PROJECT_SOURCE_DIR}
      )
    
    if (NOT CLOUDY_SOURCE)
      set (CLOUDY_SOURCE ${CLOUDY_URL})
    endif (NOT CLOUDY_SOURCE)
    
  endif (CLOUDY_FROM_REPOS)
  
else (NOT CLOUDY_FOUND OR CLOUDY_FORCE_BUILD)
  
  add_custom_target (cloudy
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CLOUDY] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CLOUDY_FOUND OR CLOUDY_FORCE_BUILD)
