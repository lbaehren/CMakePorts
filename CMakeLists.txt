
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
##==============================================================================

find_program (HOSTNAME_COMMAND NAMES hostname )
find_program (SUDO_COMMAND     NAMES sudo     )

if (HOSTNAME_COMMAND)
  exec_program (${HOSTNAME_COMMAND} ARGS OUTPUT_VARIABLE CMAKE_SYSTEM_HOSTNAME)
endif (HOSTNAME_COMMAND)

##__________________________________________________________
## Handle option: Use sudo when installing package?

if (ENABLE_SUDO_INSTALL AND SUDO_COMMAND)
  
else (ENABLE_SUDO_INSTALL AND SUDO_COMMAND)
  set ( PORT_INSTALL_COMMAND sudo )
else (ENABLE_SUDO_INSTALL AND SUDO_COMMAND)
  set ( PORT_INSTALL_COMMAND "" )
endif (ENABLE_SUDO_INSTALL AND SUDO_COMMAND)

## ==============================================================================
##
##  Project settings & sub-directories
##
## ==============================================================================

if (NOT VERBOSE_CONFIGURE)
  ## Private components
  set ( LOCAL_REPOSITORIES_FIND_QUIETLY TRUE )
  ## Search for ported packages
  set ( APR_FIND_QUIETLY          TRUE )
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
  set ( MPC_FIND_QUIETLY          TRUE )
  set ( MPFR_FIND_QUIETLY         TRUE )
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

list (INSERT CMAKE_INCLUDE_PATH 0 ${CMAKE_INSTALL_PREFIX})
list (INSERT CMAKE_INCLUDE_PATH 0 ${CMAKE_INSTALL_PREFIX}/include)

list (INSERT CMAKE_LIBRARY_PATH 0 ${CMAKE_INSTALL_PREFIX})
list (INSERT CMAKE_LIBRARY_PATH 0 ${CMAKE_INSTALL_PREFIX}/lib)

##____________________________________________________________________
##                                                        Installation

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
      set (CMAKE_INSTALL_PREFIX "/opt" CACHE PATH "Installation prefix" FORCE)
    endif (APPLE)
  endif (UNIX)
endif (PORTS_INSTALL_PREFIX)

if (NOT EXISTS ${CMAKE_INSTALL_PREFIX})
  message (STATUS "Installation location ${CMAKE_INSTALL_PREFIX} does not exist yet.")
endif (NOT EXISTS ${CMAKE_INSTALL_PREFIX})

## Local clone of code repositories

if (ENABLE_LOCAL_REPOSITORIES)
  add_subdirectory (repositories)
endif (ENABLE_LOCAL_REPOSITORIES)

## Ports of software packages

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
message (STATUS " CMake configuration:"                                          )
message (STATUS " .. CMake executable             = ${CMAKE_COMMAND}"            )
message (STATUS " .. CMake version                = ${CMAKE_VERSION}"            )
message (STATUS " .. Module path                  = ${CMAKE_MODULE_PATH}"        )
message (STATUS " .. Installation prefix          = ${CMAKE_INSTALL_PREFIX}"     )
message (STATUS " .. Installation command         = ${PORT_INSTALL_COMMAND} make install"     )
message (STATUS " Project configuration:"                                        )
message (STATUS " .. Local repository clones      = ${LOCAL_REPOSITORIES}"       )

message (STATUS "+------------------------------------------------------------+")
