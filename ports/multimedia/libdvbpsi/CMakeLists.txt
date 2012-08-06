
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LIBDVBPSI)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (LIBDVBPSI_VERSION        "0.2.2" )
set (LIBDVBPSI_SOURCE_ARCHIVE "libdvbpsi-${LIBDVBPSI_VERSION}.tar.gz" )
set (LIBDVBPSI_URL            "http://download.videolan.org/pub/libdvbpsi/${LIBDVBPSI_VERSION}/${LIBDVBPSI_SOURCE_ARCHIVE}" )
set (LIBDVBPSI_GIT            "git://git.videolan.org/libdvbpsi.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LIBDVBPSI_FORCE_BUILD    "Force build and installation of package?" NO )
option (LIBDVBPSI_FROM_REPOS     "Install package from repository?"         NO  )
option (LIBDVBPSI_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (LIBDVBPSI_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (LIBDVBPSI_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (LIBDVBPSI)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LIBDVBPSI_FROM_REPOS)
  set (LIBDVBPSI_FORCE_BUILD TRUE)
endif (LIBDVBPSI_FROM_REPOS)

if (NOT LIBDVBPSI_FOUND OR LIBDVBPSI_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (LIBDVBPSI_SOURCE ${LIBDVBPSI_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT LIBDVBPSI_SOURCE)
    set (LIBDVBPSI_SOURCE ${LIBDVBPSI_URL})
  endif (NOT LIBDVBPSI_SOURCE)
  
  ## Build package from source
  
  if (LIBDVBPSI_FROM_REPOS)
    
    ExternalProject_Add (libdvbpsi
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${LIBDVBPSI_GIT}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (LIBDVBPSI_FROM_REPOS)
    
    ExternalProject_Add (libdvbpsi
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${LIBDVBPSI_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (LIBDVBPSI_FROM_REPOS)
  
else (NOT LIBDVBPSI_FOUND OR LIBDVBPSI_FORCE_BUILD)
  
  add_custom_target (libdvbpsi
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[libdvbpsi] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT LIBDVBPSI_FOUND OR LIBDVBPSI_FORCE_BUILD)
