
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBVORBIS)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBVORBIS_VERSION        "1.3.2" )
set (LIBVORBIS_SOURCE_ARCHIVE "libvorbis-${LIBVORBIS_VERSION}.tar.gz" )
set (LIBVORBIS_URL            "ftp://ftp.videolan.org/pub/videolan/contrib/${LIBVORBIS_SOURCE_ARCHIVE}" )
set (LIBVORBIS_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBVORBIS_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBVORBIS_FROM_REPOS     "Install package from repository?"         NO )
option (LIBVORBIS_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBVORBIS_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBVORBIS_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (LibVorbis)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBVORBIS_FROM_REPOS)
  set (LIBVORBIS_FORCE_BUILD TRUE)
endif (LIBVORBIS_FROM_REPOS)

if (NOT LIBVORBIS_FOUND OR LIBVORBIS_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBVORBIS_SOURCE ${LIBVORBIS_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBVORBIS_SOURCE)
    set (LIBVORBIS_SOURCE ${LIBVORBIS_URL})
  endif (NOT LIBVORBIS_SOURCE)
  
  ## Build package from source
  
  if (LIBVORBIS_FROM_REPOS)
    
    ExternalProject_Add (libvorbis
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${LIBVORBIS_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBVORBIS_FROM_REPOS)
    
    ExternalProject_Add (libvorbis
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBVORBIS_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBVORBIS_FROM_REPOS)
  
else (NOT LIBVORBIS_FOUND OR LIBVORBIS_FORCE_BUILD)
  
  add_custom_target (libvorbis
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libvorbis] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBVORBIS_FOUND OR LIBVORBIS_FORCE_BUILD)
