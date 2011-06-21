
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Name of the project handled by CMake
project (CMakePorts)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ENABLE_LOCAL_REPOSITORIES "Enable keeping local repository clones?" NO )
option (VERBOSE_CONFIGURE         "Be verbose during configuration?"        NO )

## ==============================================================================
##
##  System inspection
##
##
##==============================================================================

## ==============================================================================
##
##  Project settings & sub-directories
##
## ==============================================================================

if (NOT VERBOSE_CONFIGURE)
  set ( APR_FIND_QUIETLY      TRUE )
  set ( BLITZ_FIND_QUIETLY    TRUE )
  set ( CFITSIO_FIND_QUIETLY  TRUE )
  set ( CPPUNIT_FIND_QUIETLY  TRUE )
  set ( GIT_FIND_QUIETLY      TRUE )
  set ( GSL_FIND_QUIETLY      TRUE )
  set ( GMP_FIND_QUIETLY      TRUE )
  set ( HDF5_FIND_QUIETLY     TRUE )
  set ( PPL_FIND_QUIETLY      TRUE )
  set ( POPT_FIND_QUIETLY     TRUE )
  set ( PTH_FIND_QUIETLY      TRUE )
  set ( READLINE_FIND_QUIETLY TRUE )
  set ( WCSLIB_FIND_QUIETLY   TRUE )
  set ( YASM_FIND_QUIETLY     TRUE )
endif (NOT VERBOSE_CONFIGURE)

##____________________________________________________________________
##                                                       CMake modules

find_path (PROJECT_CMAKE_MODULES template_FindXX.cmake
  PATHS ${PROJECT_SOURCE_DIR}
  share
  share/cmake
  cmake
  PATH_SUFFIXES Modules
  )

if (PROJECT_CMAKE_MODULES)
  set (CMAKE_MODULE_PATH ${PROJECT_CMAKE_MODULES} CACHE PATH
    "CMake module path"
    FORCE)
endif (PROJECT_CMAKE_MODULES)

##____________________________________________________________________
##                                              Required CMake modules

include (ExternalProject)
include (CTest)
enable_testing()

##____________________________________________________________________
##                                                    Search locations

list (APPEND CMAKE_INCLUDE_PATH ${CMAKE_INSTALL_PREFIX})
list (APPEND CMAKE_INCLUDE_PATH ${CMAKE_INSTALL_PREFIX}/include)

list (APPEND CMAKE_LIBRARY_PATH ${CMAKE_INSTALL_PREFIX})
list (APPEND CMAKE_LIBRARY_PATH ${CMAKE_INSTALL_PREFIX}/lib)

##____________________________________________________________________
##                                                        Installation

if (UNIX)
  if (APPLE)
    set (CMAKE_INSTALL_PREFIX "/sw" CACHE PATH "Installation prefix" FORCE)
  else (APPLE)
    set (CMAKE_INSTALL_PREFIX "/opt" CACHE PATH "Installation prefix" FORCE)
  endif (APPLE)
endif (UNIX)

if (NOT EXISTS ${CMAKE_INSTALL_PREFIX})
  message (STATUS "Installation location ${CMAKE_INSTALL_PREFIX} does not exist yet.")
endif (NOT EXISTS ${CMAKE_INSTALL_PREFIX})

## Ports of software packages

add_subdirectory (ports)

## Local clone of code repositories

if (ENABLE_LOCAL_REPOSITORIES)
  add_subdirectory (repositories)
endif (ENABLE_LOCAL_REPOSITORIES)

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "+------------------------------------------------------------+")

message (STATUS "CMAKE_SYSTEM             = ${CMAKE_SYSTEM}"             )
message (STATUS "CMAKE_SYSTEM_NAME        = ${CMAKE_SYSTEM_NAME}"        )
message (STATUS "CMAKE_SYSTEM_PROCESSOR   = ${CMAKE_SYSTEM_PROCESSOR}"   )
message (STATUS "CMAKE_SYSTEM_VERSION     = ${CMAKE_SYSTEM_VERSION}"     )
message (STATUS "CMAKE_MODULE_PATH        = ${CMAKE_MODULE_PATH}"        )
message (STATUS "PROJECT_CMAKE_MODULES    = ${PROJECT_CMAKE_MODULES}"    )
message (STATUS "LOCAL_REPOSITORIES_FOUND = ${LOCAL_REPOSITORIES_FOUND}" )

message (STATUS "+------------------------------------------------------------+")
