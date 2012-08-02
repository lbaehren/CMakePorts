
##
##  Rice (rice.rubyforge.org) is a C++ interface to Ruby's C API. It provides
##  a type-safe and exception-safe interface in order to make embedding Ruby
##  and writing Ruby extensions with C++ easier. It is similar to Boost.Python
##  in many ways, but also attempts to provide an object-oriented interface
##  to all of the Ruby C API.
##

## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (RICE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (RICE_VERSION        "" )
set (RICE_SOURCE_ARCHIVE "" )
set (RICE_URL            "" )
set (RICE_GIT            "git://github.com/jameskilton/rice.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (RICE_FORCE_BUILD    "Force build and installation of package?" NO  )
option (RICE_FROM_REPOS     "Install package from repository?"         YES )
option (RICE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (RICE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (RICE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#find_package (RICE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (RICE_FROM_REPOS)
  set (RICE_FORCE_BUILD TRUE)
endif (RICE_FROM_REPOS)

if (NOT RICE_FOUND OR RICE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (RICE_SOURCE ${RICE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT RICE_SOURCE)
    set (RICE_SOURCE ${RICE_URL})
  endif (NOT RICE_SOURCE)
  
  ## Build package from source
  
  if (RICE_FROM_REPOS)
    
    ExternalProject_Add (rice
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${RICE_GIT}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/bootstrap
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (RICE_FROM_REPOS)
    
    ExternalProject_Add (rice
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${RICE_SOURCE}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/bootstrap
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (RICE_FROM_REPOS)
  
else (NOT RICE_FOUND OR RICE_FORCE_BUILD)
  
  add_custom_target (rice
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[rice] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT RICE_FOUND OR RICE_FORCE_BUILD)
