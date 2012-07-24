
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (EXIV2)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (EXIV2_VERSION        "0.23" )
set (EXIV2_SOURCE_ARCHIVE "exiv2-${EXIV2_VERSION}.tar.gz" )
set (EXIV2_URL            "http://www.exiv2.org/${EXIV2_SOURCE_ARCHIVE}" )
set (EXIV2_SVN            "svn://dev.exiv2.org/svn/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (EXIV2_FORCE_BUILD    "Force build and installation of package?" NO )
option (EXIV2_FROM_REPOS     "Install package from repository?"         NO )
option (EXIV2_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (EXIV2_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (EXIV2_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_package (Exiv2)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (EXIV2_FROM_REPOS)
  set (EXIV2_FORCE_BUILD TRUE)
endif (EXIV2_FROM_REPOS)

if (NOT EXIV2_FOUND OR EXIV2_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (EXIV2_SOURCE ${EXIV2_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT EXIV2_SOURCE)
    set (EXIV2_SOURCE ${EXIV2_URL})
  endif (NOT EXIV2_SOURCE)
  
  ## Build package from source
  
  if (EXIV2_FROM_REPOS)
    
    ExternalProject_Add (exiv2
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${EXIV2_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (EXIV2_FROM_REPOS)
    
    ExternalProject_Add (exiv2
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${EXIV2_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (EXIV2_FROM_REPOS)
  
else (NOT EXIV2_FOUND OR EXIV2_FORCE_BUILD)
  
  add_custom_target (exiv2
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[exiv2] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT EXIV2_FOUND OR EXIV2_FORCE_BUILD)
