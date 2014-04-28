# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2011                                                        |
# |   Lars B"ahren (lbaehren@gmail.com)                                         |
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

# - Check for the presence of MATROSKA
#
# The following variables are set when MATROSKA is found:
#  MATROSKA_FOUND      = Set to true, if all components of MATROSKA
#                         have been found.
#  MATROSKA_INCLUDES   = Include path for the header files of MATROSKA
#  MATROSKA_LIBRARIES  = Link these to use MATROSKA
#  MATROSKA_LFLAGS     = Linker flags (optional)

if (NOT MATROSKA_FOUND)
    
  if (NOT MATROSKA_ROOT_DIR)
    set (MATROSKA_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT MATROSKA_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (MATROSKA_INCLUDES matroska/KaxConfig.h c/libmatroska.h
    HINTS ${MATROSKA_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (MATROSKA_LIBRARIES matroska
    HINTS ${MATROSKA_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (MATROSKA_INCLUDES AND MATROSKA_LIBRARIES)
    set (MATROSKA_FOUND TRUE)
  else (MATROSKA_INCLUDES AND MATROSKA_LIBRARIES)
    set (MATROSKA_FOUND FALSE)
    if (NOT MATROSKA_FIND_QUIETLY)
      if (NOT MATROSKA_INCLUDES)
	message (STATUS "Unable to find MATROSKA header files!")
      endif (NOT MATROSKA_INCLUDES)
      if (NOT MATROSKA_LIBRARIES)
	message (STATUS "Unable to find MATROSKA library files!")
      endif (NOT MATROSKA_LIBRARIES)
    endif (NOT MATROSKA_FIND_QUIETLY)
  endif (MATROSKA_INCLUDES AND MATROSKA_LIBRARIES)
  
  if (MATROSKA_FOUND)
    if (NOT MATROSKA_FIND_QUIETLY)
      message (STATUS "Found components for MATROSKA")
      message (STATUS "MATROSKA_ROOT_DIR  = ${MATROSKA_ROOT_DIR}")
      message (STATUS "MATROSKA_INCLUDES  = ${MATROSKA_INCLUDES}")
      message (STATUS "MATROSKA_LIBRARIES = ${MATROSKA_LIBRARIES}")
    endif (NOT MATROSKA_FIND_QUIETLY)
  else (MATROSKA_FOUND)
    if (MATROSKA_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find MATROSKA!")
    endif (MATROSKA_FIND_REQUIRED)
  endif (MATROSKA_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    MATROSKA_INCLUDES
    MATROSKA_LIBRARIES
    )
  
endif (NOT MATROSKA_FOUND)
