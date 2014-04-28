#-------------------------------------------------------------------------------
# Copyright (c) 2014, Lars Baehren <lbaehren@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#-------------------------------------------------------------------------------

## =============================================================================
##
##  CMake project settings
##
## =============================================================================

## Name of the project handled by CMake
project (CMakePorts)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8.2)

## Enforced CMake policy
cmake_policy (VERSION 2.8.2)

## Project release version (major.minor.patch)
set (PROJECT_VERSION_MAJOR 0 )
set (PROJECT_VERSION_MINOR 1 )
set (PROJECT_VERSION_PATCH 0 )
set (PROJECT_VERSION_SERIES "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")
set (PROJECT_VERSION "${PROJECT_VERSION_SERIES}.${PROJECT_VERSION_PATCH}")

## =============================================================================
##
##  Options
##
## =============================================================================


option (ENABLE_SUDO_INSTALL       "Use sudo when installing package?"       NO  )
option (ENABLE_LOCAL_REPOSITORIES "Enable keeping local repository clones?" NO  )
option (VERBOSE_CONFIGURE         "Be verbose during configuration?"        NO  )
option (ENABLE_TESTING            "Enable CTest test driver?"               NO  )

## =============================================================================
##
##  System inspection
##
## =============================================================================

find_program (HOSTNAME_COMMAND NAMES hostname )

if (HOSTNAME_COMMAND)
  exec_program (${HOSTNAME_COMMAND} ARGS OUTPUT_VARIABLE CMAKE_SYSTEM_HOSTNAME)
endif (HOSTNAME_COMMAND)

##__________________________________________________________
## Handle option: Enable CTest test driver?

if (ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (ENABLE_TESTING)

##__________________________________________________________
## Handle option: Use sudo when installing package?

if (ENABLE_SUDO_INSTALL)
  set ( PORT_INSTALL_COMMAND sudo )
else (ENABLE_SUDO_INSTALL)
  set ( PORT_INSTALL_COMMAND "" )
endif (ENABLE_SUDO_INSTALL)

##__________________________________________________________
## Handle option: Enable keeping local repository clones?

if (ENABLE_LOCAL_REPOSITORIES)
  include (AddRepositories)
endif (ENABLE_LOCAL_REPOSITORIES)


## =============================================================================
##
##  Project settings & sub-directories
##
## =============================================================================

include (ExternalProject)

##____________________________________________________________________
##                                             (Verbose) configuration

if (NOT VERBOSE_CONFIGURE)
  ## Private components
  set ( LOCAL_REPOSITORIES_FIND_QUIETLY TRUE )
  foreach (varPackage
      APR
      AUTOCONF
      BLITZ
      CFITSIO
      CPPUNIT
      EXIV2
      GHOSTSCRIPT
      GIT
      GSL
      GMP
      HDF5
      ICONV
      LAPACK
      LLVM
      MATROSKA
      MPC
      MPFR
      OPENMPI
      PELICAN
      PPL
      POPT
      PTH
      PYTHON
      QT
      READLINE
      SILO
      SLANG
      SQLITE
      WCSLIB
      YASM
      )
    set (${varPackage}_FIND_QUIETLY TRUE )
  endforeach (varPackage)
endif (NOT VERBOSE_CONFIGURE)

##____________________________________________________________________
##                                                       CMake modules

list (INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

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

## =============================================================================
##
##  Project build instructions
##
## =============================================================================

add_subdirectory (ports)

## =============================================================================
##
##  Configuration summary
##
## =============================================================================

message ( "------------------------------------------------------------"   )
message ( "[${PROJECT_NAME}] Configuration summary."                       )
message ( "------------------------------------------------------------ "  )
message ( " * System configuration"                                        )
message ( "  .. Processor type ............. = ${CMAKE_SYSTEM_PROCESSOR}"  )
message ( "  .. CMake executable ........... = ${CMAKE_COMMAND}"           )
message ( "  .. CMake version .............. = ${CMAKE_VERSION}"           )
message ( "  .. System name ................ = ${CMAKE_SYSTEM_NAME}"       )
message ( "  .. System version ............. = ${CMAKE_SYSTEM_VERSION}"    )
message ( "  .. C compiler ................. = ${CMAKE_C_COMPILER}"        )
message ( "  .. C compiler flags ........... = ${CMAKE_C_FLAGS}"           )
message ( "  .. C++ compiler ............... = ${CMAKE_CXX_COMPILER}"      )
message ( "  .. C++ compiler flags ......... = ${CMAKE_CXX_FLAGS}"         )
message ( "  .. Memory checker ............. = ${MEMORYCHECK_COMMAND}"     )
message ( " * CMake configuration:"                                        )
message ( "  .. CMake executable ........... = ${CMAKE_COMMAND}"           )
message ( "  .. CMake version .............. = ${CMAKE_VERSION}"           )
message ( "  .. Module path . = ${CMAKE_MODULE_PATH}"                      )
message ( "  .. Installation prefix ........ = ${CMAKE_INSTALL_PREFIX}"    )
message ( "  .. OS X architectures ......... = ${CMAKE_OSX_ARCHITECTURES}" )
message ( " * MacPorts configuration:"                                     )
message ( "------------------------------------------------------------ "  )





