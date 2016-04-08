
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CMAKE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (CMAKE_VERSION_SERIES "2.8" )
set (CMAKE_VERSION_PATCH  "8" )
set (CMAKE_VERSION        "${CMAKE_VERSION_SERIES}.${CMAKE_VERSION_PATCH}" )
set (CMAKE_SOURCE_ARCHIVE "cmake-${CMAKE_VERSION}.tar.gz" )
set (CMAKE_URL            "http://www.cmake.org/files/v${CMAKE_VERSION_SERIES}/${CMAKE_SOURCE_ARCHIVE}" )
set (CMAKE_GIT            "git://cmake.org/cmake.git")

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CMAKE_FORCE_BUILD    "Force build and installation of package?" NO  )
option (CMAKE_FROM_REPOS     "Install package from repository?"         YES )
option (CMAKE_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (CMAKE_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (CMAKE_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_package (Git)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CMAKE_FROM_REPOS AND GIT_FOUND)
  set (CMAKE_FORCE_BUILD TRUE)
endif (CMAKE_FROM_REPOS AND GIT_FOUND)

if (NOT CMAKE_FOUND OR CMAKE_FORCE_BUILD)

  ## Locate source file to build from

  find_file (CMAKE_SOURCE ${CMAKE_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT CMAKE_SOURCE)
    set (CMAKE_SOURCE ${CMAKE_URL})
  endif (NOT CMAKE_SOURCE)

  ## Build package from source

  if (CMAKE_FROM_REPOS)

    ExternalProject_Add (cmake
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${CMAKE_GIT}
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (CMAKE_FROM_REPOS)

    ExternalProject_Add (cmake
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${CMAKE_SOURCE}
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  endif (CMAKE_FROM_REPOS)

else (NOT CMAKE_FOUND OR CMAKE_FORCE_BUILD)

  add_custom_target (cmake
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CMake] Found system-wide installation; skipping rebuild!"
    )

endif (NOT CMAKE_FOUND OR CMAKE_FORCE_BUILD)
