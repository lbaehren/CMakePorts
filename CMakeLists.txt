
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

option (ENABLE_SUDO_INSTALL       "Use sudo when installing package?"       NO  )
option (ENABLE_LOCAL_REPOSITORIES "Enable keeping local repository clones?" YES )
option (VERBOSE_CONFIGURE         "Be verbose during configuration?"        NO  )

## ==============================================================================
##
##  System inspection
##
##===============================================================================

find_program (HOSTNAME_COMMAND NAMES hostname )

if (HOSTNAME_COMMAND)
  exec_program (${HOSTNAME_COMMAND} ARGS OUTPUT_VARIABLE CMAKE_SYSTEM_HOSTNAME)
endif (HOSTNAME_COMMAND)

##__________________________________________________________
## Handle option: Use sudo when installing package?

if (ENABLE_SUDO_INSTALL)
  set ( PORT_INSTALL_COMMAND sudo )
else (ENABLE_SUDO_INSTALL)
  set ( PORT_INSTALL_COMMAND "" )
endif (ENABLE_SUDO_INSTALL)

## ==============================================================================
##
##  Project settings & sub-directories
##
## ==============================================================================

##____________________________________________________________________
##                                             (Verbose) configuration

if (NOT VERBOSE_CONFIGURE)
  ## Private components
  set ( LOCAL_REPOSITORIES_FIND_QUIETLY TRUE )
  ## Search for ported packages
  set ( APR_FIND_QUIETLY          TRUE )
  set ( AUTOCONF_FIND_QUIETLY     TRUE )
  set ( BLITZ_FIND_QUIETLY        TRUE )
  set ( CFITSIO_FIND_QUIETLY      TRUE )
  set ( CPPUNIT_FIND_QUIETLY      TRUE )
  set ( GHOSTSCRIPT_FIND_QUIETLY  TRUE )
  set ( GIT_FIND_QUIETLY          TRUE )
  set ( GSL_FIND_QUIETLY          TRUE )
  set ( GMP_FIND_QUIETLY          TRUE )
  set ( HDF5_FIND_QUIETLY         TRUE )
  set ( ICONV_FIND_QUIETLY        TRUE )
  set ( LAPACK_FIND_QUIETLY       TRUE )
  set ( MATROSKA_FIND_QUIETLY     TRUE )
  set ( MPC_FIND_QUIETLY          TRUE )
  set ( MPFR_FIND_QUIETLY         TRUE )
  set ( OPENMPI_FIND_QUIETLY      TRUE )
  set ( PELICAN_FIND_QUIETLY      TRUE )
  set ( PPL_FIND_QUIETLY          TRUE )
  set ( POPT_FIND_QUIETLY         TRUE )
  set ( PTH_FIND_QUIETLY          TRUE )
  set ( PYTHON_FIND_QUIETLY       TRUE )
  set ( QT_FIND_QUIETLY           TRUE )
  set ( READLINE_FIND_QUIETLY     TRUE )
  set ( SILO_FIND_QUIETLY         TRUE )
  set ( SLANG_FIND_QUIETLY        TRUE )
  set ( WCSLIB_FIND_QUIETLY       TRUE )
  set ( YASM_FIND_QUIETLY         TRUE )
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

foreach (_pathBase
    /usr/local
    /usr
    /opt/local
    /sw
    ${CMAKE_INSTALL_PREFIX}
    )

  ## Locations to search for header files
  list (INSERT CMAKE_INCLUDE_PATH 0 ${_pathBase}/include )
  ## Locations to search for libraries
  list (INSERT CMAKE_LIBRARY_PATH 0 ${_pathBase}         )
  list (INSERT CMAKE_LIBRARY_PATH 0 ${_pathBase}/lib     )
  ## Locations to search for program executables
  list (INSERT CMAKE_PROGRAM_PATH 0 ${_pathBase}/bin     )

endforeach (_pathBase)

##____________________________________________________________________
##                                               Installation location

if (PORTS_INSTALL_PREFIX)
  set (CMAKE_INSTALL_PREFIX ${PORTS_INSTALL_PREFIX} CACHE PATH
    "Installation prefix"
    FORCE
    )
else (PORTS_INSTALL_PREFIX)
  if (UNIX)
    if (APPLE)
      set (CMAKE_INSTALL_PREFIX "/sw" CACHE PATH "Installation prefix" FORCE)
    else (APPLE)
      set (CMAKE_INSTALL_PREFIX "/opt/local" CACHE PATH "Installation prefix" FORCE)
    endif (APPLE)
  endif (UNIX)
endif (PORTS_INSTALL_PREFIX)

if (NOT EXISTS ${CMAKE_INSTALL_PREFIX})
  message (STATUS "Installation location ${CMAKE_INSTALL_PREFIX} does not exist yet.")
endif (NOT EXISTS ${CMAKE_INSTALL_PREFIX})

##____________________________________________________________________
##                                         Build architectures for OSX

if (APPLE)

  message (STATUS "Detecting OSX architecture")
  
  if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "i386")
    set (CMAKE_OSX_ARCHITECTURES "i386" CACHE STRING
      "Build architectures for OSX"
      FORCE
      )
  endif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "i386")
  
  if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
    set (CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING
      "Build architectures for OSX"
      FORCE
      )
  endif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  
  if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "powerpc")
    set (CMAKE_OSX_ARCHITECTURES "ppc" CACHE STRING
      "Build architectures for OSX"
      FORCE
      )
  endif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "powerpc")
  
  message (STATUS "Detecting OSX architecture - ${CMAKE_OSX_ARCHITECTURES}")
  
endif (APPLE)

##____________________________________________________________________
##                                         Cache initialization script

configure_file (
  ${CMakePorts_SOURCE_DIR}/configure.cmake.in
  ${CMakePorts_BINARY_DIR}/configure.cmake
  )

##____________________________________________________________________
##                                    Local clone of code repositories

if (ENABLE_LOCAL_REPOSITORIES)
  add_subdirectory (repositories)
endif (ENABLE_LOCAL_REPOSITORIES)

##____________________________________________________________________
##                                          Ports of software packages

add_subdirectory (ports)

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "==============================================================" )
message (STATUS "[CMakePorts] Configuration summary:"                            )
message (STATUS "+------------------------------------------------------------+" )

message (STATUS " System configuration:"                                         )
message (STATUS " .. Hostname                     = ${CMAKE_SYSTEM_HOSTNAME}"    )
message (STATUS " .. Processor type               = ${CMAKE_SYSTEM_PROCESSOR}"   )
message (STATUS " .. System name                  = ${CMAKE_SYSTEM}"             )
message (STATUS " .. C++ compiler                 = ${CMAKE_CXX_COMPILER}"       )
message (STATUS " .. C compiler                   = ${CMAKE_C_COMPILER}"         )
message (STATUS " .. size(void*)                  = ${CMAKE_SIZEOF_VOID_P}"      )
message (STATUS " CMake configuration:"                                          )
message (STATUS " .. CMake executable             = ${CMAKE_COMMAND}"            )
message (STATUS " .. CMake version                = ${CMAKE_VERSION}"            )
message (STATUS " .. Module path                  = ${CMAKE_MODULE_PATH}"        )
message (STATUS " .. Installation prefix          = ${CMAKE_INSTALL_PREFIX}"     )
message (STATUS " .. OS X architectures           = ${CMAKE_OSX_ARCHITECTURES}"  )
message (STATUS " Project configuration:"                                        )
message (STATUS " .. Local repository clones      = ${LOCAL_REPOSITORIES}"       )

message (STATUS "+------------------------------------------------------------+")
