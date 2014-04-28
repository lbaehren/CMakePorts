# +-----------------------------------------------------------------------------+
# | $Id::                                                                     $ |
# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2007                                                        |
# |   Lars B"ahren (bahren@astron.nl)                                           |
# |                                                                             |
# |   This program is free software; you can redistribute it and/or modify      |
# |   it under the terms of the GNU General Public License as published by      |
# |   the Free Software Foundation; either version 2 of the License, or         |
# |   (at your option) any later version.                                       |
# |                                                                             |
# |   This program is distributed in the hope that it will be useful,           |
# |   but WITHOUT ANY WARRANTY; without even the implied warranty of            |
# |   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             |
# |   GNU General Public License for more details.                              |
# |                                                                             |
# |   You should have received a copy of the GNU General Public License         |
# |   along with this program; if not, write to the                             |
# |   Free Software Foundation, Inc.,                                           |
# |   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                 |
# +-----------------------------------------------------------------------------+

# - Check for the presence of PELICAN
#
# The following variables are set when PELICAN is found:
#  PELICAN_FOUND       = Set to true, if all components of PELICAN have been found.
#  PELICAN_INCLUDES   = Include path for the header files of PELICAN
#  PELICAN_LIBRARIES  = Link these to use PELICAN
#  PELICAN_LFLAGS     = Linker flags (optional)

if (NOT FIND_PELICAN_CMAKE)
  
  set (FIND_PELICAN_CMAKE TRUE)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (PELICAN_INCLUDES pelican/comms/ServerRequest.h
    PATHS /usr /usr/local /sw ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include include/pelican
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (PELICAN_LIBRARIES pelican
    PATHS /usr /usr/local /sw ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the CMake modules directory
  
  find_path (PELICAN_CMAKE_MODULE_DIR FindPelicanInstall.cmake
    PATHS
    /usr/
    /usr/share
    /usr/share/pelican
    /usr/share/pelican/cmake
    /usr/local/
    /usr/local/share
    /usr/local/share/pelican
    /usr/local/share/pelican/cmake
    $ENV{PELICAN_INSTALL_DIR}/share/pelican/cmake
    ${PELICAN_INSTALL_DIR}/share/pelican/cmake
    ${CMAKE_INSTALL_PREFIX}
    ${CMAKE_INSTALL_PREFIX}/share
    ${CMAKE_INSTALL_PREFIX}/share/pelican
    PATH_SUFFIXES
    share
    cmake
    pelican
    DOC
    "Location of Pelican CMake modules."
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (PELICAN_INCLUDES AND PELICAN_LIBRARIES AND PELICAN_CMAKE_MODULE_DIR)
    set (PELICAN_FOUND TRUE)
  else (PELICAN_INCLUDES AND PELICAN_LIBRARIES AND PELICAN_CMAKE_MODULE_DIR)
    set (PELICAN_FOUND FALSE)
    if (NOT PELICAN_FIND_QUIETLY)
      if (NOT PELICAN_INCLUDES)
	message (STATUS "Unable to find PELICAN header files!")
      endif (NOT PELICAN_INCLUDES)
      if (NOT PELICAN_LIBRARIES)
	message (STATUS "Unable to find PELICAN library files!")
      endif (NOT PELICAN_LIBRARIES)
    endif (NOT PELICAN_FIND_QUIETLY)
  endif (PELICAN_INCLUDES AND PELICAN_LIBRARIES AND PELICAN_CMAKE_MODULE_DIR)
  
  if (PELICAN_FOUND)
    if (NOT PELICAN_FIND_QUIETLY)
      message (STATUS "[FindPELICAN] Configuration summary.")
      message (STATUS "PELICAN_INCLUDES         = ${PELICAN_INCLUDES}")
      message (STATUS "PELICAN_LIBRARIES        = ${PELICAN_LIBRARIES}")
      message (STATUS "PELICAN_CMAKE_MODULE_DIR = ${PELICAN_CMAKE_MODULE_DIR}")
    endif (NOT PELICAN_FIND_QUIETLY)
  else (PELICAN_FOUND)
    if (PELICAN_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find PELICAN!")
    endif (PELICAN_FIND_REQUIRED)
  endif (PELICAN_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    PELICAN_INCLUDES
    PELICAN_LIBRARIES
    PELICAN_CMAKE_MODULE_DIR
    )
  
endif (NOT FIND_PELICAN_CMAKE)
